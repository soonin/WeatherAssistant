//
//  API.swift
//  WeatherAssistant
//
//  Created by Pooya on 2018-09-28.
//  Copyright © 2018 Pooya. All rights reserved.
//

import Foundation


class ApiJson {
    
    
    // sample URLs from Assignment
    //    final let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=0&lon=0&appid=c6e381d8c7ff98f0fee43775817cf6ad&units=metric"
    //    final let urlString1 = "https://api.openweathermap.org/data/2.5/forecast?lat=0&lon=0&appid=c6e381d8c7ff98f0fee43775817cf6ad&units=metric
    
    
    let apiURL = "https://api.openweathermap.org/data/2.5/"
    let apiToken : String = ""
    let apiKey : String = "c6e381d8c7ff98f0fee43775817cf6ad"
    var lon : Float = 0.0
    var lat : Float = 0.0
    var units : String = "metric"
    var requestType : String = "" //  "weather"  // "forecast"
    
    // Generic Function to read JSON output and convert it to Model
    func getModelViaJsonWithURL<T : Decodable>() -> T {
        var sampleModel : T!
        let semaphore = DispatchSemaphore(value: 0)
        let url = NSURL(string: apiURL + parameterMaker())
        print(apiURL + parameterMaker())
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            do {
                //let decoder = JSONDecoder()
                sampleModel = try JSONDecoder().decode(T.self, from: data)
                semaphore.signal()
            } catch {
                semaphore.signal()
                print(error)
            }
        }).resume()
        
        semaphore.wait()
        return sampleModel
    }
    
    
    // WeatherModel Function to read JSON output and convert it to Model
    func getWeatherViaJsonWithURL() -> WeatherModel {
        var weatherModel : WeatherModel!
        let semaphore = DispatchSemaphore(value: 0)
        let url = NSURL(string: apiURL + parameterMaker())
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            do {
                weatherModel = try JSONDecoder().decode(WeatherModel.self, from: data)
                semaphore.signal()
            } catch {
                weatherModel = WeatherModel()
                semaphore.signal()
                print(error)
            }
        }).resume()
        
        semaphore.wait()
        return weatherModel
    }
    
    
    // ForecastModel Function to read JSON output and convert it to Model
    func getForecastViaJsonWithURL() -> ForecastModel {
        var forecastModel : ForecastModel!
        let semaphore = DispatchSemaphore(value: 0)
        let url = NSURL(string: apiURL + parameterMaker())
        print(apiURL + parameterMaker())
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            do {
                forecastModel = try JSONDecoder().decode(ForecastModel.self, from: data)
                semaphore.signal()
            } catch {
                print(error)
            }
        }).resume()
        
        semaphore.wait()
        return forecastModel
    }
    
    
    // Function to make URL match with api
    func parameterMaker() -> String {
        var outputString : String = ""
        outputString += requestType + "?"
        outputString += "lat=" + String(lat) + "&"
        outputString += "lon=" + String(lon) + "&"
        outputString += "appid=" + apiKey + "&"
        outputString += "units=" + units
        
        return outputString
    }
    
    
}
