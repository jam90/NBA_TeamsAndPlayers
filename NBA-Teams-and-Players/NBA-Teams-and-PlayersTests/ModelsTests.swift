//
//  ModelsTests.swift
//  NBA-Teams-and-PlayersTests
//
//  Created by Elia Crocetta on 03/04/21.
//

import XCTest
@testable import NBA_Teams_and_Players

class ModelsTests: XCTestCase {
    
    var player: Player?
    var team: Team?
    var error: ErrorMessage?
    var resultData: ResultData<Player>?

    override func setUpWithError() throws {
        try super.setUpWithError()
        player = Player.dummy
        team = Team.dummy
        error = ErrorMessage(customMessage: "This is a custom error message")
        
        resultData = ResultData(data: Array.init(repeating: Player.dummy, count: 10), meta: Meta.dummyFirstPage)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        player = nil
        team = nil
        error = nil
    }

    func testPlayersAreNotEqual() {
        var player2 = Player.dummy
        player2.id = 35
        XCTAssertNotEqual(player, player2, "This players are the same")
    }
    
    func testTeamAreNotEqual() {
        var team2 = Team.dummy
        team2.abbreviation = "BBB"
        XCTAssertNotEqual(team, team2, "This teams are the same")
    }
    
    func testErrorGotMessage() {
        XCTAssertNotNil(error?.message, "This error has got no message")
    }

}
