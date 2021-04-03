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
    var resultDataPlayers: ResultData<Player>?
    var resultDataTeams: ResultData<Team>?

    override func setUpWithError() throws {
        try super.setUpWithError()
        player = Player.dummy
        team = Team.dummy
        error = ErrorMessage(customMessage: "This is a custom error message")
        resultDataPlayers = ResultData(data: Array.init(repeating: Player.dummy, count: 10), meta: Meta.dummyFirstPage)
        resultDataTeams = ResultData(data: Array.init(repeating: Team.dummy, count: 10), meta: Meta.dummyFirstPage)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        player = nil
        team = nil
        error = nil
        resultDataPlayers = nil
        resultDataTeams = nil
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
//        error?.message = nil
        XCTAssertNotNil(error?.message, "This error has got no message")
    }
    
    func testResultPlayersHasData() {
//        resultDataPlayers?.data = nil
        XCTAssertNotNil(resultDataPlayers?.data, "This result has no data")
    }
    
    func testResultPlayersIsNotEmpty() {
        guard let players = resultDataPlayers?.data else { XCTFail("The data is nil"); return }
//        players.removeAll()
        XCTAssertFalse(players.isEmpty, "This result has no data")
    }
    
    func testResultTeamHasData() {
        XCTAssertNotNil(resultDataTeams?.data, "This result has no data")
    }
    
    func testResultTeamIsNotEmpty() {
        guard let teams = resultDataTeams?.data else { XCTFail("The data is nil"); return }
        XCTAssertFalse(teams.isEmpty, "This result has no data")
    }
    
    func testResultPlayersCanGoNextPage() {
        resultDataPlayers?.meta = Meta.dummyFirstPage
        XCTAssertNotNil(resultDataPlayers?.meta.nextPage, "Next page is nil, so this is the last page: can't move forward")
    }
    
    func testResultTeamsCanGoNextPage() {
        resultDataTeams?.meta = Meta.dummyFirstPage
        XCTAssertNotNil(resultDataTeams?.meta.nextPage, "Next page is nil, so this is the last page: can't move forward")
    }
    
    func testResultPlayersIsLastPage() {
        resultDataPlayers?.meta = Meta.dummyLastPage
        XCTAssertNil(resultDataPlayers?.meta.nextPage, "Next page is not nil, so this is not the last page")
    }
    
    func testResultTeamsIsLastPage() {
        resultDataTeams?.meta = Meta.dummyLastPage
        XCTAssertNil(resultDataTeams?.meta.nextPage, "Next page is not nil, so this is not the last page")
    }

}
