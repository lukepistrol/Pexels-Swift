//
//  HTTPURLResponse+.swift
//  
//
//  Created by Lukas Pistrol on 23.05.22.
//

import Foundation

public extension HTTPURLResponse {
    var pexelsLimit: Int? {
        Int(self.value(forHTTPHeaderField: PexelsSwift.RateLimitType.limit.rawValue) ?? "")
    }

    var pexelsRemaining: Int? {
        Int(self.value(forHTTPHeaderField: PexelsSwift.RateLimitType.remaining.rawValue) ?? "")
    }

    var pexelsReset: Date? {
        guard let interval = Double(self.value(forHTTPHeaderField: PexelsSwift.RateLimitType.reset.rawValue) ?? "")
        else { return nil }
        return Date(timeIntervalSince1970: interval)
    }
}
