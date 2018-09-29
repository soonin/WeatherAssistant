//
//  DaysInfo.swift
//  WeatherAssistant
//
//  Created by Pooya on 2018-09-28.
//  Copyright © 2018 Pooya. All rights reserved.
//

import Foundation

// DaysInfo Struct for simplifying "Forecast" for tableview 
struct DaysInfo {
    var dt : TimeInterval
    var dt_txt : String
    var temp : String
    var humidity : String
    var main : String
    var description : String
    var speed : String
    var deg : String
    
    init(){
        self.dt = 0
        self.dt_txt = ""
        self.temp = ""
        self.humidity = ""
        self.main = ""
        self.description = ""
        self.speed = ""
        self.deg = ""
    }
    
}
