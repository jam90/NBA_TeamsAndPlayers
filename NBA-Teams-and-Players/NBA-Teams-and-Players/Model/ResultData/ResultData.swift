//
//  ResultData.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import Foundation

struct ResultData<T : Codable> : Codable {
    
    let data: [T]?
    let meta: Meta

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case meta = "meta"
    }

}
