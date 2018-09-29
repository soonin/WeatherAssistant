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
    
    
}
