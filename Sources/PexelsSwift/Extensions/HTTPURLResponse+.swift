//
//  HTTPURLResponse+.swift
//  
//
//  Created by Lukas Pistrol on 23.05.22.
//

import Foundation

public extension HTTPURLResponse {
    /// Returns an integer describing the Pexels API call limit, if set.
    ///
    /// - Note: This will only be set if a API call was made previously.
    var pexelsLimit: Int? {
        Int(self.value(forHTTPHeaderField: PexelsSwift.RateLimitType.limit.rawValue) ?? "")
    }

    /// Returns an integer describing the Pexels API remaining calls, if set.
    ///
    /// - Note: This will only be set if a API call was made previously.
    var pexelsRemaining: Int? {
        Int(self.value(forHTTPHeaderField: PexelsSwift.RateLimitType.remaining.rawValue) ?? "")
    }

    /// Returns a date describing the reset date for the `pexelsLimit`, if set.
    ///
    /// - Note: This will only be set if a API call was made previously.
    var pexelsReset: Date? {
        guard let interval = Double(self.value(forHTTPHeaderField: PexelsSwift.RateLimitType.reset.rawValue) ?? "")
        else { return nil }
        return Date(timeIntervalSince1970: interval)
    }
}
