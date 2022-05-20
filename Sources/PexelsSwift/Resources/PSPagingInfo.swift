//
//  PSPagingInfo.swift
//  
//
//  Created by Lukas Pistrol on 19.05.22.
//

import Foundation

/// Metadata useful for paging (page, total results, next page, ...)
public struct PSPagingInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case totalResults = "total_results"
        case previousPage = "prev_page"
        case nextPage = "next_page"
    }
    /// The current page
    public var page: Int

    /// The number of results on this page
    public var perPage: Int

    /// The total number of results
    public var totalResults: Int

    /// The URL-Path of the previous page if available.
    public var previousPage: String?

    /// The URL-Path of the next page if available.
    public var nextPage: String?
}
