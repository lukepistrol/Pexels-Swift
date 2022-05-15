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
    /// string value in the [HTTPURLResponse](https://developer.apple.com/documentation/foundation/httpurlresponse) object.
    enum RateLimit: String {
        case limit = "X-Ratelimit-Limit"
        case remaining = "X-Ratelimit-Remaining"
        case reset = "X-Ratelimit-Reset"


        /// Returns the corresponding
        /// string value in the [HTTPURLResponse](https://developer.apple.com/documentation/foundation/httpurlresponse) object.
        /// - Parameters:
        ///   - response: The response.
        ///   - type: The type.
        /// - Returns: A string.
        static func value(for response: HTTPURLResponse, type: Self) -> String {
            response.value(forHTTPHeaderField: type.rawValue) ?? ""
        }
    }
}
