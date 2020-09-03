//
//  RewritorUITests.swift
//  RewritorUITests
//
//  Created by Kyle Howells on 02/09/2020.
//

import XCTest

class RewritorUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
		setupSnapshot(app)
        app.launch()
		
		if UIDevice.current.userInterfaceIdiom == .pad {
			XCUIDevice.shared.orientation = .landscapeLeft
		}
		
		Thread.sleep(until: Date(timeIntervalSinceNow: 0.5))
		
		let fingerPaintingTxtNavigationBar = app.navigationBars["Finger Painting.txt"]
		
		snapshot("0FingerPaintingNormal")
		
		fingerPaintingTxtNavigationBar.buttons["ellipsis"].tap()
		
		snapshot("1Settings")
		
		let incrementButton = app.tables/*@START_MENU_TOKEN@*/.buttons["Increment"]/*[[".cells.buttons[\"Increment\"]",".buttons[\"Increment\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		incrementButton.tap() // 13
		incrementButton.tap() // 14
		incrementButton.tap() // 15
		incrementButton.tap() // 16
		incrementButton.tap() // 17
		incrementButton.tap() // 18
		incrementButton.tap() // 19
		incrementButton.tap() // 20
		incrementButton.tap() // 21
		incrementButton.tap() // 22
		incrementButton.tap() // 23
		incrementButton.tap() // 24
		incrementButton.tap() // 25
		incrementButton.tap() // 26
		incrementButton.tap() // 27
		incrementButton.tap() // 28
		incrementButton.tap() // 29
		incrementButton.tap() // 30
		app.navigationBars["About Rewritor"].buttons["Close"].tap()
		
		snapshot("2FingerPaintingLarge")
		
		fingerPaintingTxtNavigationBar.buttons["Close"].tap()
		
		Thread.sleep(until: Date(timeIntervalSinceNow: 0.5))
		
		snapshot("3Quotes")
		
		app.navigationBars["Quotes.txt"].buttons["Close"].tap()
		
		snapshot("4Files")
    }
}
