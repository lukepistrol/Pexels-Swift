//
//  File.swift
//  
//
//  Created by Lukas Pistrol on 12.05.22.
//

import Foundation

extension PexelsSwift {
    struct ContentResults: Codable {
        enum CodingKeys: String, CodingKey {
            case photos, media, page
            case perPage = "per_page"
            case totalResults = "total_results"
            case previousPage = "prev_page"
            case nextPage = "next_page"
        }
        var photos: Array<PSPhoto>? // When searching, or featured
        var media: Array<PSPhoto>? // When fetching from collections
        var page: Int
        var perPage: Int
        var totalResults: Int
        var previousPage: String?
        var nextPage: String?
    }

    struct CollectionResults: Codable {
        enum CodingKeys: String, CodingKey {
            case collections, page
            case perPage = "per_page"
            case totalResults = "total_results"
            case previousPage = "prev_page"
            case nextPage = "next_page"
        }

        var collections: Array<CollectionCategory>
        var page: Int
        var perPage: Int
        var totalResults: Int
        var previousPage: String?
        var nextPage: String?
    }
}
