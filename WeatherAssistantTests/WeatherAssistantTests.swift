//
//  WeatherAssistantTests.swift
//  WeatherAssistantTests
//
//  Created by Pooya on 2018-09-25.
//  Copyright © 2018 Pooya. All rights reserved.
//

import XCTest
@testable import WeatherAssistant

class WeatherAssistantTests: XCTestCase {

    // initial location in case of Location was off
    var keyLocationName = "East Palo Alto"
    var keyLat = "37.47"
    var keyLon = "-122.14"
    
    // relative number to scale font size based on device screen size
    let relativeFontWelcomeTitle:CGFloat = 0.045
    let relativeFontButton:CGFloat = 0.030
    let relativeFontCellTitle:CGFloat = 0.043
    let relativeFontCellDescription:CGFloat = 0.025
    
    // array(s) to show in collection
    var bookmarkedArray : [BookmarkedEntity] = []
    var knownArray : [KnownEntity] = []
    
    // refrenced for classes
    var bookmarkedTools = BookmarkedTools()
    var knownTools = KnownTools()
    var settingsMem = DefaultsSettings()
    var api = ApiJson()
    
    // initial Value for Setting
    var collectionSource : String = "Bookmarked"
    var seacrhMethod : String = "def"
    var unitsInit : String = "metric"
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testfetchNotEmptyBookmarkedEntity()  {
        bookmarkedArray = bookmarkedTools.fetchData()
        let result = bookmarkedArray.count
        print(result)
        XCTAssert(result != 0)
    }
    
    
    func testsaveSettingsAndloadSettings()  {
        let valuetosave : String = "This is a test case for testing saveSettings and loadSettings functions!"
        let keyForSave : String = "myTestKey"
        settingsMem.saveSettings(keyName: keyForSave, keyValue: valuetosave)
        let savedValue = settingsMem.loadSettings(keyName: keyForSave)
        print(savedValue)
        XCTAssert(valuetosave == savedValue)
    }
    
    
    func testgetForecastViaJsonWithURL()  {
        api.lat = keyLat.toFloat()
        api.lon = keyLon.toFloat()
        api.requestType = "forecast"
        api.units = unitsInit
        let forecast = api.getForecastViaJsonWithURL()
        XCTAssert(forecast.city.name == "East Palo Alto")
    }
    
    func testgetForecastViaJsonWithURLFORforecast()  {
        api.lat = keyLat.toFloat()
        api.lon = keyLon.toFloat()
        api.requestType = "forecast"
        api.units = unitsInit
        let forecast : ForecastModel = api.getModelViaJsonWithURL()
        XCTAssert(forecast.city.name == "East Palo Alto")
    }
    
    
    func testgetWeatherViaJsonWithURL()  {
        api.lat = keyLat.toFloat()
        api.lon = keyLon.toFloat()
        api.requestType = "weather"
        api.units = unitsInit
        let weather = api.getWeatherViaJsonWithURL()
        XCTAssert(weather.name == "East Palo Alto")
    }
    
    func testgetModelViaJsonWithURLFORweather()  {
        api.lat = keyLat.toFloat()
        api.lon = keyLon.toFloat()
        api.requestType = "weather"
        api.units = unitsInit
        let weather : WeatherModel = api.getModelViaJsonWithURL()
        XCTAssert(weather.name == "East Palo Alto")
    }

    
}
