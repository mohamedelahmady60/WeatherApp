//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    //is gonna be responsible for getting hold of the current GPS location of the phone
    // create it in the info.plist file
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ask the user for permission
        locationManager.requestWhenInUseAuthorization()
        
        //set the delegate
        locationManager.delegate = self

        //get the location for one time
        locationManager.requestLocation()
        
        //set the delegate
        searchTextField.delegate = self
        
        //set the delegate
        weatherManager.delegate = self
        
        
    }
    @IBAction func locationButtonGotPressed(_ sender: UIButton) {
        //get the location for one time
        locationManager.requestLocation()

    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonGotPressed(_ sender: UIButton) {
        
        // close the keyboard
        searchTextField.endEditing(true)
    }
    
    //protocol function must be defined to use it
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // end editing to close the keyboard
        textField.endEditing(true)
        return true
    }
    
    //protocol function must be defined to use it
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        // check if user entered data or not
        if textField.text != "" {
            return true //end the editing
        }else {
            textField.placeholder = "Type something here!"
            return false//don't end the editing
        }
    }
    
    
    //protocol function must be defined to use it
    func textFieldDidEndEditing(_ textField: UITextField) {
        //catch the value that user entered
        if let cityName = textField.text {
            //pass the city name in order to get the current weather
            weatherManager.fetchWeather(City: cityName)
        }
        
        //remove the text from the text field
        textField.text = ""
    }
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async { // Correct
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(_ weatherManager:WeatherManager, error: Error) {
        print(error)
    }
    
    
}


//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // locations in an array of several locations
        // last item is the most acurate one
        if let location = locations.last {
            
            locationManager.stopUpdatingLocation()
            
            //get tha latitude and the longitude
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            //pass the latitude and longitude in order to get the current weather
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
