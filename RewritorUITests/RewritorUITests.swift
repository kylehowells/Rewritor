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
		
		snapshot("0Launch")
		
		app/*@START_MENU_TOKEN@*/.navigationBars["FullDocumentManagerViewControllerNavigationBar"]/*[[".otherElements[\"Browse View\"].navigationBars[\"FullDocumentManagerViewControllerNavigationBar\"]",".navigationBars[\"FullDocumentManagerViewControllerNavigationBar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["gear"].tap()
		
		snapshot("1Settings")
		
		app.navigationBars["About Rewritor"].buttons["Close"].tap()
		
		snapshot("1Settings")
		
		Thread.sleep(until: Date(timeIntervalSinceNow: 0.5))
		
		
    }
}
