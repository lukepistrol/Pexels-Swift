//
//  PSError.swift
//  
//
//  Created by Lukas Pistrol on 14.05.22.
//

import Foundation

/// Error Type indicating why an operation has failed
public enum PSError: Error, Equatable {

    public typealias ErrorDescription = String

    case generic(ErrorDescription)
    case noAPIKey
    case noContent
    case badURL
    case noResponse
    case httpResponse(Int)

    /// Retrieve the description for this error.
    public var description: String {
        switch self {
        case .generic(let error):
            return "Generic Error: \(error)"
        case .noAPIKey:
            return "No API key was set. Call `setup(apiKey:logLevel:)` before making a request"
        case .noContent:
            return "No content was found"
        case .badURL:
            return "Not a valid URL"
        case .noResponse:
            return "No response from server"
        case .httpResponse(let code):
            return "HTTP Error. Status code: \(code)"
        }
    }
}
