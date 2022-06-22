//
//  PSError.swift
//  
//
//  Created by Lukas Pistrol on 14.05.22.
//

import Foundation

/// Error Type indicating why an operation has failed
///
/// To print out the error just call its ``description`` property.
public enum PSError: Error, Equatable {

    /// A string describing the error.
    public typealias ErrorDescription = String

    /// A generic error with a description.
    case generic(ErrorDescription)

    /// An error indicating that no API Key was set.
    case noAPIKey

    /// An error indicating that no content (photos, videos, media) was returned.
    case noContent

    /// An error indicating a bad URL request. Passes a description of the url.
    case badURL(ErrorDescription)

    /// An error indicating there was no response from the server.
    case noResponse(ErrorDescription)

    /// An error indicating a non `2**` HTTP response.
    case httpResponse(Int)

    /// Retrieve the description for this error.
    public var description: String {
        switch self {
        case .generic(let description):
            return "Generic Error: \(description)"
        case .noAPIKey:
            return "No API key was set. Call `setup(apiKey:logLevel:)` before making a request"
        case .noContent:
            return "No content was found"
        case .badURL(let description):
            return "Not a valid URL: \(description)"
        case .noResponse(let description):
            return "No response from server: \(description)"
        case .httpResponse(let code):
            return "HTTP Error. Status code: \(code)"
        }
    }
}
