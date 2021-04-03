//
//  Player.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import Foundation

struct Player : Codable, Hashable {
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id &&
            lhs.first_name == rhs.first_name &&
            lhs.height_feet == rhs.height_feet &&
            lhs.height_inches == rhs.height_inches &&
            lhs.last_name == rhs.last_name &&
            lhs.position == rhs.position &&
            lhs.team == rhs.team &&
            lhs.weight_pounds == rhs.weight_pounds
    }
    
    var id : Int?
    var first_name : String?
    var height_feet : Double?
    var height_inches : Double?
    var last_name : String?
    var position : String?
    var team : Team?
    var weight_pounds : Double?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case first_name = "first_name"
        case height_feet = "height_feet"
        case height_inches = "height_inches"
        case last_name = "last_name"
        case position = "position"
        case team = "team"
        case weight_pounds = "weight_pounds"
    }
    
    static var dummy: Player {
        return Player(id: 20, first_name: "John", height_feet: 6.0, height_inches: 1.0, last_name: "Doe", position: "F", team: Team.dummy, weight_pounds: 200.0)
    }

}
