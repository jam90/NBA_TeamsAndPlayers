//
//  NBA_Teams_and_PlayersUITests.swift
//  NBA-Teams-and-PlayersUITests
//
//  Created by Elia Crocetta on 01/04/21.
//

import XCTest

class NBA_Teams_and_PlayersUITests: XCTestCase {

    var app: XCUIApplication?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app?.launch()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app = nil
    }
    
    
    func testOnBoarding() throws {
        guard let app = self.app else {XCTFail("App instance is nil"); return}
        
        app.navigationBars.firstMatch.children(matching: .button).element.tap()
        
        let element = app.scrollViews.children(matching: .other).element.children(matching: .other).element
        element.swipeLeft()
        element.swipeLeft()
        element.swipeRight()
        element.swipeRight()
        element.swipeLeft(velocity: .fast)
        element.swipeLeft(velocity: .fast)
        let mainButton = app.buttons.element(matching: .button, identifier: "mainButton")
        mainButton.tap()
    }
    
    func testScrollingTeamsList() throws {
        guard let app = self.app else {XCTFail("App instance is nil"); return}
        
        let tableView = app.tables.firstMatch
        tableView.swipeUp(velocity: .fast)
        tableView.swipeUp(velocity: .fast)
        tableView.swipeUp(velocity: .fast)
        tableView.swipeUp(velocity: .fast)
        tableView.swipeUp(velocity: .fast)
        tableView.swipeDown(velocity: .fast)
        tableView.swipeDown(velocity: .fast)
        tableView.swipeDown(velocity: .fast)
        tableView.swipeDown(velocity: .fast)
        tableView.swipeDown(velocity: .fast)
    }
    
    func testOpenTeamDetailAndBack() {
        guard let app = self.app else {XCTFail("App instance is nil"); return}
        
        app.cells.firstMatch.tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
    }
    
    func testOpenTeamDetailAndSelectPlayer() {
        guard let app = self.app else {XCTFail("App instance is nil"); return}
        
        app.cells.firstMatch.tap()
        app.cells.firstMatch.buttons.element(boundBy: 0).tap()
        app.buttons.element(matching: .button, identifier: "closeDetailPlayer").tap()
        app.tables.firstMatch.swipeUp(velocity: .fast)
        app.tables.firstMatch.swipeDown(velocity: .fast)
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
