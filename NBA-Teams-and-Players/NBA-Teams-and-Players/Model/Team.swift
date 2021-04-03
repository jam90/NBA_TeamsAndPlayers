//
//  Team.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import Foundation

struct Team : Codable, Hashable {
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.id == rhs.id &&
            lhs.abbreviation == rhs.abbreviation &&
            lhs.city == rhs.city &&
            lhs.conference == rhs.conference &&
            lhs.division == rhs.division &&
            lhs.full_name == rhs.full_name &&
            lhs.name == rhs.name
    }
    
    var id : Int?
    var abbreviation : String?
    var city : String?
    var conference : String?
    var division : String?
    var full_name : String?
    var name : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case abbreviation = "abbreviation"
        case city = "city"
        case conference = "conference"
        case division = "division"
        case full_name = "full_name"
        case name = "name"
    }
    
    static var dummy: Team {
        return Team(id: 40, abbreviation: "AAA", city: "DummyCity", conference: "West", division: "Pacific", full_name: "DummyCity Swifties", name: "Swifties")
    }

}
