//
//  PexelsSwift+RateLimit.swift
//  
//
//  Created by Lukas Pistrol on 15.05.22.
//

import Foundation

internal extension PexelsSwift {
    /// Keys for getting Rate Limit statistics from response headers.
    ///
    /// Use the `value(for:type:)` function to get the corresponding
    /// string value in the 
    /// [HTTPURLResponse](https://developer.apple.com/documentation/foundation/httpurlresponse) object.
    enum RateLimitType: String {
        case limit = "X-Ratelimit-Limit"
        case remaining = "X-Ratelimit-Remaining"
        case reset = "X-Ratelimit-Reset"
    }
}

public extension PexelsSwift {

    /// Struct that holds the most recent values for Rate Limit staticstics
    ///
    /// See <doc:Rate-Limits> for more information.
    struct RateLimit {

        /// The monthly limit of API calls.
        public var limit: Int?

        /// The remaining calls within the ``limit``.
        public var remaining: Int?

        /// The reset date when ``remaining`` gets reset to ``limit``.
        public var reset: Date?
    }
}
