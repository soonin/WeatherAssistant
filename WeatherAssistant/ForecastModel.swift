//
//  ForecastModel.swift
//  WeatherAssistant
//
//  Created by Pooya on 2018-09-28.
//  Copyright © 2018 Pooya. All rights reserved.
//

import Foundation


// Forecast Model Encodable & Decodable macth with openweathermap.org api
struct ForecastModel: Decodable {
    var city : City
    var code: String
    var message: Float
    var cnt : Int
    var list : [TopList]
    
    //  swift 4.0 Custom Coding Strategy
    private enum CodingKeys: String, CodingKey {
        case code = "cod"
        case city, message, cnt, list
    }
    
} //End of struct WeatherModel: Decodable


struct City : Decodable {
    var name : String
    
    // Custom Coding Strategy
    private enum CodingKeys: String, CodingKey {
        case name
    }
}

struct TopList : Decodable {
    var dt : TimeInterval
    var main : ListMain
    var weather : [ListWeather]
    var wind : ListWind
    var dt_txt : String
    
    // Custom Coding Strategy
    private enum CodingKeys: String, CodingKey {
        case dt, wind, main, weather, dt_txt
    }
}

struct ListMain : Decodable {
    var temp : Float
    var temp_min : Float
    var temp_max : Float
    var pressure : Float
    var humidity : Float
    
    // Custom Coding Strategy
    private enum CodingKeys: String, CodingKey {
        case temp, temp_min, temp_max,pressure, humidity
        
    }
}

struct ListWeather : Decodable {
    var id : Int
    var main : String
    var description : String
    
    // Custom Coding Strategy
    private enum CodingKeys: String, CodingKey {
        case id, main, description
    }
}

struct ListWind : Decodable {
    var speed : Float
    var deg : Float
    
    // Custom Coding Strategy
    private enum CodingKeys: String, CodingKey {
        case speed, deg
    }
}
