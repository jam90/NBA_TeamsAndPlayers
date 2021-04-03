//
//  ErrorMessage.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import Foundation

struct ErrorMessage : Codable {
    var message : String?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
    
    init(customMessage: String) {
        self.message = customMessage
    }

}
