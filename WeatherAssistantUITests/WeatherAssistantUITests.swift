//
//  WeatherAssistantUITests.swift
//  WeatherAssistantUITests
//
//  Created by Pooya on 2018-09-25.
//  Copyright © 2018 Pooya. All rights reserved.
//

import XCTest
@testable import WeatherAssistant

class WeatherAssistantUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasicUISettingPage() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.swipeDown()
        app/*@START_MENU_TOKEN@*/.buttons["Bookmarks"]/*[[".segmentedControls.buttons[\"Bookmarks\"]",".buttons[\"Bookmarks\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Weather Assistant"].children(matching: .button).matching(identifier: "Item").element(boundBy: 1).tap()
        app/*@START_MENU_TOKEN@*/.buttons["Imperial"]/*[[".segmentedControls.buttons[\"Imperial\"]",".buttons[\"Imperial\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Case InSensitive"]/*[[".segmentedControls.buttons[\"Case InSensitive\"]",".buttons[\"Case InSensitive\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Settings page"].buttons["Weather Assistant"].tap()
    }

}
