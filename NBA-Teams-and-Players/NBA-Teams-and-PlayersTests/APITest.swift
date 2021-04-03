//
//  APITest.swift
//  NBA-Teams-and-PlayersTests
//
//  Created by Elia Crocetta on 03/04/21.
//

import XCTest
@testable import NBA_Teams_and_Players

class APITest: XCTestCase {
    
    var api: APIManager?
    var player: Player?
    var team: Team?

    override func setUpWithError() throws {
        try super.setUpWithError()
        self.api = APIManager.shared
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.api = nil
        self.player = nil
        self.team = nil
    }
    
    func testPlayersAPI() {
        guard let api = self.api else {XCTFail("The singleton is not initialized"); return}
        
        let expAllPlayers = expectation(description: "200 OK")
        api.getAllPlayers(page: 0) { [weak self] result in
            self?.player = result.data?.first
            expAllPlayers.fulfill()
        } failure: { error in
            XCTFail(error.message ?? "")
        }
        waitForExpectations(timeout: 15) //15 is the timeout set in APIManager class
        
        guard let player = self.player, let id = player.id else {XCTFail("No player found"); return}
        var playerFetched: Player? = nil
        let expSinglePlayer = expectation(description: "200 OK")
        api.getSpecificPlayer(id: "\(id)") { player in
            playerFetched = player
            expSinglePlayer.fulfill()
        } failure: { error in
            XCTFail(error.message ?? "")
        }
        waitForExpectations(timeout: 15) //15 is the timeout set in APIManager class
        
        XCTAssertNotNil(self.player, "The player found in first API call is nil")
        XCTAssertNotNil(playerFetched, "The player found in second API call is nil")
        XCTAssertEqual(self.player, playerFetched, "This players are not the same")

    }
    
    func testTeamsAPI() {
        guard let api = self.api else {XCTFail("The singleton is not initialized"); return}
        
        let expAllTeams = expectation(description: "200 OK")
        api.getAllTeams(page: 0) { [weak self] result in
            self?.team = result.data?.first
            expAllTeams.fulfill()
        } failure: { error in
            XCTFail(error.message ?? "")
        }
        waitForExpectations(timeout: 15) //15 is the timeout set in APIManager class
        
        guard let team = self.team, let id = team.id else {XCTFail("No team found"); return}
        var teamFetched: Team? = nil
        let expSingleTeam = expectation(description: "200 OK")
        api.getSpecificTeam(id: "\(id)") { team in
            teamFetched = team
            expSingleTeam.fulfill()
        } failure: { error in
            XCTFail(error.message ?? "")
        }
        waitForExpectations(timeout: 15) //15 is the timeout set in APIManager class
        
        XCTAssertNotNil(self.team, "The team found in first API call is nil")
        XCTAssertNotNil(teamFetched, "The team found in second API call is nil")
        XCTAssertEqual(self.team, teamFetched, "This teams are not the same")
    }

    func testGetTeamLogo() {
        guard let api = self.api else {XCTFail("The singleton is not initialized"); return}
        
        let expAllTeams = expectation(description: "200 OK")
        api.getAllTeams(page: 0) { [weak self] result in
            self?.team = result.data?.first
            expAllTeams.fulfill()
        } failure: { error in
            XCTFail(error.message ?? "")
        }
        waitForExpectations(timeout: 15) //15 is the timeout set in APIManager class
        
        var logoImage: UIImage? = nil
        let expLogo = expectation(description: "200 OK")
        guard let team = self.team, let abbr = team.abbreviation else {XCTFail("No team found"); return}
        api.getTeamLogo(abbreviation: abbr) { image in
            logoImage = image
            expLogo.fulfill()
        }
        waitForExpectations(timeout: 15) //15 is the timeout set in APIManager class
        
        XCTAssertNotNil(logoImage, "The image is nil")
        
    }

}
