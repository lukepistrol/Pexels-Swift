//
//  PSLogLevel.swift
//  
//
//  Created by Lukas Pistrol on 15.05.22.
//

import Foundation

/// A collection of log levels.
public enum PSLogLevel {
    /// Nothing will be logged.
    case off
    /// Only errors will be logged.
    case error
    /// Only errors and responses will be logged
    case info
    /// Errors, responses, and data will be logged
    case debug
}
