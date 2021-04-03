//
//  Meta.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import Foundation

struct Meta: Codable  {
    
    var totalPages  : Int
    var currentPage : Int
    var nextPage    : Int?
    var perPage     : Int
    var totalCount  : Int
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case currentPage = "current_page"
        case nextPage = "next_page"
        case perPage = "per_page"
        case totalCount = "total_count"
    }
    
    static var dummyFirstPage: Meta {
        return Meta(totalPages: 10, currentPage: 1, nextPage: 2, perPage: 20, totalCount: 1000)
    }
    
    static var dummyLastPage: Meta {
        return Meta(totalPages: 10, currentPage: 10, nextPage: nil, perPage: 20, totalCount: 1000)
    }
    
}
