//
//  PexelsSwift+Results.swift
//  
//
//  Created by Lukas Pistrol on 12.05.22.
//

import Foundation

extension PexelsSwift {
    /// Content Results Wrapper with generic type `<T>`
    struct ContentResults<T: Codable>: Codable {
        enum CodingKeys: String, CodingKey {
            case photos, media, videos, page
            case perPage = "per_page"
            case totalResults = "total_results"
            case previousPage = "prev_page"
            case nextPage = "next_page"
        }
        var photos: [PSPhoto]? // When searching, or featured
        var media: [T]? // When fetching from collections
        var videos: [PSVideo]? // When fetching videos
        var page: Int
        var perPage: Int
        var totalResults: Int
        var previousPage: String?
        var nextPage: String?
    }

    /// Collection Results Wrapper
    struct CollectionResults: Codable {
        enum CodingKeys: String, CodingKey {
            case collections, page
            case perPage = "per_page"
            case totalResults = "total_results"
            case previousPage = "prev_page"
            case nextPage = "next_page"
        }

        var collections: [PSCollection]
        var page: Int
        var perPage: Int
        var totalResults: Int
        var previousPage: String?
        var nextPage: String?
    }
}
