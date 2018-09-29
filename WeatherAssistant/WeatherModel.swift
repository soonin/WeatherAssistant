//
//  WeatherModel.swift
//  WeatherAssistant
//
//  Created by Pooya on 2018-09-28.
//  Copyright © 2018 Pooya. All rights reserved.
//

import Foundation

// Weather Model Encodable & Decodable macth with openweathermap.org api
// We have already Weather Keyword in swift so we name this model : WeatherModel
struct WeatherModel: Decodable {
    var id: Int   // City IDC
    var name: String // ity name
    var cod : Int  //Internal parameter
    //    var sys : Sys
    //    var dt : String  //Time of data calculation, unix, UTC
    //    var snow : Snow
    //    var rain : Rain
    //    var clouds : Clouds
    var wind : Wind
    var main : Main
    //    var base : String// Internal parameter
    var weather: [Weather]
    var coord: Coord
    
    //  swift 4.0 Custom Coding Strategy
    private enum CodingKeys: String, CodingKey {
        case id, name, cod, wind, main, weather, coord
    }
    
    init(){
        self.id = 0
        self.name = ""
        self.cod = 0
        //    var sys : Sys
        //    var dt : String  //Time of data calculation, unix, UTC
        //    var snow : Snow
        //    var rain : Rain
        //    var clouds : Clouds
        self.wind = Wind()
        self.main = Main()
        //    var base : String// Internal parameter
        self.weather = []
        self.coord = Coord()

    }
    
} //End of struct WeatherModel: Decodable

struct Rain : Decodable {
    var rain3h : String   // Snow volume for the last 3 hours
    
    // Custom Coding Strategy
    private enum CodingKeys: String, CodingKey {
        case rain3h = "3h"
    }
}

struct Wind : Decodable {
    var speed : Float   // Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
    var deg : Float   // Wind direction, degrees (meteorological)
    
    // Custom Coding Strategy
    private enum CodingKeys: String, CodingKey {
        case speed, deg
    }
    
    init(){
        self.speed = 0
        self.deg = 0
    }
}

struct Main : Decodable {
    var temp : Float   // Weather condition id
    var pressure : Float // Group of weather parameters (Rain, Snow, Extreme etc.)
    var humidity : Float  // Weather condition within the group
    
    // Custom Coding Strategy
    private enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
    }
    init(){
        self.temp = 0
        self.pressure = 0
        self.humidity = 0
    }

}

struct Coord : Decodable {
    var lon : Double   // City geo location, longitude
    var lat : Double // City geo location, latitude
    
    // Custom Coding Strategy
    private enum CodingKeys: String, CodingKey {
        case lon, lat
    }
    init(){
        self.lon = 0
        self.lat = 0
    }

}


struct Weather : Decodable {
    var main : String   // Group of weather parameters (Rain, Snow, Extreme etc.)
    var description : String // Weather condition within the group
    
    // Custom Coding Strategy
    private enum CodingKeys: String, CodingKey {
        case main, description
    }
}
