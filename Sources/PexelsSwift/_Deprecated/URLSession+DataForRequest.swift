//
//  URLSession+DataForRequest.swift
//  
//
//  Created by Lukas Pistrol on 17.05.22.
//

import Foundation

@available(iOS, deprecated: 15, message: "Use the built-in API instead")
@available(macOS, deprecated: 12, message: "Use the built-in API instead")
extension URLSession {
    /// Downloads the contents of a URL based on the specified URL request and delivers the data asynchronously.
    ///
    /// This is a legacy implementation for `URLSession.data(for:)` prior to iOS 15 and macOS 12.
    /// - Parameter request: A URL request object that provides request-specific information such as the URL, cache policy, request type, and body data or body stream.
    /// - Returns: An asynchronously-delivered tuple that contains the URL contents as a `Data` instance, and a `URLResponse`.
    func _data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }
}
