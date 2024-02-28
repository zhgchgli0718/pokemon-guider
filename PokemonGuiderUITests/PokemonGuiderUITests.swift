//
//  PokemonGuiderUITests.swift
//  PokemonGuiderUITests
//
//  Created by zhgchgli on 2024/2/28.
//

import XCTest

final class PokemonGuiderUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTabBarTap() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["myProfile"].tap()
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: "label == %@", "敬請期待")).count > 0)
        
        tabBarsQuery.buttons["pokemonList"].tap()
        XCTAssertTrue(app.navigationBars.matching(identifier: "所有寶可夢").count > 0)
    }
    
    func testTapPokemonToDetail() throws {
        let app = XCUIApplication()
        app.launch()

        sleep(1)
        let firstCell = app.collectionViews.firstMatch.cells.element(boundBy: 0)
        let pokemonName = firstCell.staticTexts["pokemonName"].label
        
        firstCell.tap()
        XCTAssertTrue(app.navigationBars.matching(identifier: pokemonName).count > 0)
    }
}
