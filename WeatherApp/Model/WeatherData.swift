//
//  WeatherData.swift
//  Clima
//
//  Created by Mo Elahmady on 9/12/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable  {
    let temp: Double
}

struct Weather: Decodable {
    let description:String
    let id: Int
}
