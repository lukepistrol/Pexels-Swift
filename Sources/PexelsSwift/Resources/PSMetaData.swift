//
//  PSMetaData.swift
//  
//
//  Created by Lukas Pistrol on 19.05.22.
//

import Foundation

/// Metadata useful for paging (page, total results, next page, ...)
public struct PSMetaData: Codable {
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case totalResults = "total_results"
        case previousPage = "prev_page"
        case nextPage = "next_page"
    }
    /// The current page
    var page: Int

    /// The number of results on this page
    var perPage: Int

    /// The total number of results
    var totalResults: Int

    /// The URL-Path of the previous page if available.
    var previousPage: String?

    /// The URL-Path of the next page if available.
    var nextPage: String?
}
