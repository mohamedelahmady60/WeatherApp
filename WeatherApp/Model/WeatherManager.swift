//
//  WeatherManager.swift
//  Clima
//
//  Created by Mo Elahmady on 9/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=a023b7955a87451d3c11279fdba97d3b&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(City cityName: String) {
        let urlString = "\(self.weatherURL)&q=\(cityName)"
        self.performRequest(with: urlString)
        
    }
    
    
    func fetchWeather(latitude: CLLocationDegrees  , longitude: CLLocationDegrees) {
          let urlString = "\(self.weatherURL)&lat=\(latitude)&lon=\(longitude)"
          self.performRequest(with: urlString)
      }
    
    
    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let urlSession = URLSession(configuration: .default)
            //3. Give URLSession a task
            let task = urlSession.dataTask(with: url){ (data, respone, error) in
                if error != nil {
                    //print("Error")
                    self.delegate?.didFailWithError(self, error: error!)
                    return
                }
                if let safeData = data {
                    //pass the data to be decoded and get the decoded date
                    if let weather =  self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            // hold data in constants
            let cityName = decodedData.name
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            
            //define an object from WatherModel struct, fill it with data and return it
            let weather = WeatherModel(conditionID: id, cityName: cityName, temperature: temp)
            return weather

        } catch {
            //print(error)
            self.delegate?.didFailWithError(self, error: error)
            return nil
        }
    }
    
    
    
}


protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel)
    func didFailWithError(_ weatherManager:WeatherManager, error: Error)
}





