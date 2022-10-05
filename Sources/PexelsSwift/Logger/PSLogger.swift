//
//  PSLogger.swift
//  
//
//  Created by Lukas Pistrol on 15.05.22.
//

import Foundation

/// The delegate for receiving log messages.
///
/// This is useful if you use a logging service like Sentry and need to inject the messages.
public protocol PSLoggerDelegate: AnyObject {
    /// This is called whenever a log happens in the scope of the ``PSLogLevel``
    func psLoggerMessageReceived(_ message: String)
}

/// A logger for displaying logs in the console.
///
/// Setup the logger through ``PexelsSwift/PexelsSwift``'s ``PexelsSwift/PexelsSwift/setup(apiKey:logLevel:)`` method.
///
/// - Note: Remember to set the ``PSLogLevel`` to ``PSLogLevel/off`` once
/// moving to `production`!
public class PSLogger {

    private typealias RateLimit = PexelsSwift.RateLimitType

    /// Returns the current ``PSLogLevel``.
    public private(set) var logLevel: PSLogLevel

    /// The delegate for receiving log messages.
    ///
    /// This is useful if you use a logging service like Sentry and need to inject the messages.
    public weak var delegate: PSLoggerDelegate?

    internal init() {
        self.logLevel = .info
    }

    /// Set the ``logLevel`` of the logger.
    /// - Parameter logLevel: The log level
    func setLogLevel(_ logLevel: PSLogLevel) {
        self.logLevel = logLevel
    }

    /// Logs a message to the console
    ///
    /// - Note: Only logs to the console if the ``logLevel`` is
    /// **not** set to ``PSLogLevel/off``
    /// - Parameter message: The message to log.
    func message(_ message: String) {
        guard logLevel != .off else { return }
        var logMessage = logTitle(for: .info)
        logMessage.append(message)
        print(logMessage)
        delegate?.psLoggerMessageReceived(logMessage)
    }

    /// Logs a ``PSError`` to the console
    ///
    /// - Note: Only logs to the console if the ``logLevel`` is
    /// set to ``PSLogLevel/error``, ``PSLogLevel/info``, or ``PSLogLevel/debug``.
    /// - Parameter error: The error to log.
    func error(_ error: PSError) {
        guard logLevel != .off else { return }
        var logMessage = logTitle(for: .error)
        logMessage.append("Error: \(error.description)")
        print(logMessage)
        delegate?.psLoggerMessageReceived(logMessage)
    }

    /// Logs a [HTTPURLResponse](https://developer.apple.com/documentation/foundation/httpurlresponse) to the console
    ///
    /// - Note: Only logs to the console if the ``logLevel`` is
    /// ``PSLogLevel/info`` or ``PSLogLevel/debug``.
    /// - Parameter response: The response to log.
    func response(_ response: HTTPURLResponse) {
        guard logLevel == .info || logLevel == .debug else { return }
        var logMessage = logTitle(for: .info)
        logMessage.append("Code: \(response.statusCode),")
        logMessage.append("URL: \(response.url?.absoluteString ?? "Invalid URL"),")
        if (200...299).contains(response.statusCode) {
            logMessage.append("Rate Limit: \(response.pexelsLimit?.string ?? "Fetching failed"),")
            logMessage.append("Remaining: \(response.pexelsRemaining?.string ?? "Fetching failed"),")
            logMessage.append("Reset on: \(response.pexelsReset?.description ?? "Fetching Failed")")
        } else {
            logMessage.append("Response: \(response.description)")
        }
        print(logMessage)
        delegate?.psLoggerMessageReceived(logMessage)
    }

    /// Logs data to the console in a prettified JSON string
    /// - Note: Only logs to the console if the ``logLevel`` is
    /// ``PSLogLevel/debug``
    /// - Parameter data: The data to log.
    func data(_ data: Data) {
        guard logLevel == .debug else { return }
        if let json = data.prettyJSON() {
            var logMessage = logTitle(for: .success)
            logMessage.append("Data: \(json)")
            print(logMessage)
            delegate?.psLoggerMessageReceived(logMessage)
        } else {
            var logMessage = logTitle(for: .warning)
            logMessage.append("Invalid JSON Data")
            print(logMessage)
            delegate?.psLoggerMessageReceived(logMessage)
        }
    }
}

extension PSLogger {
    private func logTitle(for logType: PSLogType) -> String {
        "\(icon(for: logType)) Pexels-Swift: "
    }

    private enum PSLogType {
        case info, success, warning, error
    }

    private func icon(for logType: PSLogType) -> String {
        switch logType {
        case .info:
            return "💬"
        case .success:
            return "✅"
        case .warning:
            return "⚠️"
        case .error:
            return "🛑"
        }
    }
}
