//
//  PSLogger.swift
//  
//
//  Created by Lukas Pistrol on 15.05.22.
//

import Foundation

/// A logger for displaying logs in the console.
///
/// Setup the logger through ``PexelsSwift/PexelsSwift``'s ``PexelsSwift/PexelsSwift/setup(apiKey:logLevel:)`` method.
///
/// - Note: Remember to set the ``PSLogLevel`` to ``PSLogLevel/off`` once
/// moving to `production`!
public struct PSLogger {

    private typealias RateLimit = PexelsSwift.RateLimit

    /// Returns the current ``PSLogLevel``.
    public private(set) var logLevel: PSLogLevel

    internal init() {
        self.logLevel = .info
    }

    /// Set the ``logLevel`` of the logger.
    /// - Parameter logLevel: The log level
    mutating
    func setLogLevel(_ logLevel: PSLogLevel) {
        self.logLevel = logLevel
    }

    /// Logs a message to the console
    ///
    /// - Note: Only logs to the console if the ``logLevel`` is
    /// **not** set to ``PSLogLevel/off``
    /// - Parameter message: The message to log.
    func log(_ message: String) {
        guard logLevel != .off else { return }
        print("💬 Pexels-Swift")
        print("\t\(message)")
    }

    /// Logs a ``PSError`` to the console
    ///
    /// - Note: Only logs to the console if the ``logLevel`` is
    /// set to ``PSLogLevel/error``, ``PSLogLevel/info``, or ``PSLogLevel/debug``.
    /// - Parameter error: The error to log.
    func logError(_ error: PSError) {
        guard logLevel != .off else { return }
        print("🛑 Pexels-Swift")
        print("\tError:", error.description)
    }

    /// Logs a [HTTPURLResponse](https://developer.apple.com/documentation/foundation/httpurlresponse) to the console
    ///
    /// - Note: Only logs to the console if the ``logLevel`` is
    /// ``PSLogLevel/info`` or ``PSLogLevel/debug``.
    /// - Parameter response: The response to log.
    func logResponse(_ response: HTTPURLResponse) {
        guard logLevel == .info || logLevel == .debug else { return }
        print("🔁 Pexels-Swift")
        print("\tCode: \(response.statusCode),")
        print("\tURL: \(response.url?.absoluteString ?? "Invalid URL")")
        if (200...299).contains(response.statusCode) {
            print("\tRate Limit: \(RateLimit.value(for: response, type: .limit))")
            print("\tRemaining: \(RateLimit.value(for: response, type: .remaining))")
            let resetDate = RateLimit.value(for: response, type: .reset)
            print("\tReset on: \(date(from: resetDate)?.description ?? "No Reset Date")")
        } else {
            print("\tResponse: \(response.description)")
        }
    }

    /// Logs data to the console in a prettified JSON string
    /// - Note: Only logs to the console if the ``logLevel`` is
    /// ``PSLogLevel/debug``
    /// - Parameter data: The data to log.
    func logData(_ data: Data) {
        guard logLevel == .debug else { return }
        if let json = data.prettyJSON() {
            print("✅ Pexels-Swift")
            print("\tData:")
            print(json)
        } else {
            print("⚠️ Pexels-Swift")
            print("\tInvalid JSON Data")
        }
    }

    /// Converts a string in the UNIX timestamp format 
    /// to [Date](https://developer.apple.com/documentation/foundation/date)
    /// - Parameter timestamp: The UNIX timestamp string.
    /// - Returns: A Date or `nil` when the timestamp is invalid.
    internal func date(from timestamp: String) -> Date? {
        if let interval = TimeInterval(timestamp) {
            return Date(timeIntervalSince1970: interval)
        }
        return nil
    }
}
