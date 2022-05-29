//
//  PexelsSwift+QueryParameter.swift
//  
//
//  Created by Lukas Pistrol on 16.05.22.
//

import Foundation

internal extension PexelsSwift {
    /// A collection of query parameters
    enum QueryParameter {
        public static let query = "query"
        public static let page = "page"
        public static let perPage = "per_page"
        public static let orientation = "orientation"
        public static let size = "size"
        public static let color = "color"
        public static let locale = "locale"
        public static let type = "type"
        public static let minWidth = "min_width"
        public static let minHeight = "min_height"
        public static let minDuration = "min_duration"
        public static let maxDuration = "max_duration"
    }
}
