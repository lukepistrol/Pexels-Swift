//
//  PexelsSwift.swift
//
//
//  Created by Lukas Pistrol on 14.05.22.
//

import Foundation

/// A singleton class for making API calls to the Pexels.com REST API.
public class PexelsSwift {

    let urlSession: URLSession

    internal init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    /// A String representing a category id.
    public typealias CategoryID = String

    /// Result type for an array of ``PSVideo``.
    public typealias VideosResult = Result<(
        data: [PSVideo],
        paging: PSPagingInfo,
        response: HTTPURLResponse
    ), PSError>

    /// Result type for a single ``PSVideo``.
    public typealias VideoResult = Result<(
        data: PSVideo,
        response: HTTPURLResponse
    ), PSError>

    /// Result type for an array of ``PSPhoto``.
    public typealias PhotosResult = Result<(
        data: [PSPhoto],
        paging: PSPagingInfo,
        response: HTTPURLResponse
    ), PSError>

    /// Result type for a single ``PSPhoto``.
    public typealias PhotoResult = Result<(
        data: PSPhoto,
        response: HTTPURLResponse
    ), PSError>

    /// Result type for an array of ``PSCollection``.
    public typealias CollectionResult = Result<(
        data: [PSCollection],
        paging: PSPagingInfo,
        response: HTTPURLResponse
    ), PSError>

    /// Result type for a generic type of `<T>`.
    internal typealias PSResult<T> = Result<(data: T, response: HTTPURLResponse), PSError>

    /// The singleton instance of ``PexelsSwift``
    public static let shared: PexelsSwift = .init()

    /// The HTTP-Header field for the API Key
    internal let apiHeader: String = "Authorization"

    /// The API key
    ///
    /// Set through ``setAPIKey(_:)``.
    internal var apiKey: String = ""

    /// An instance of ``PSLogger``
    internal var logger: PSLogger = .init()

    // MARK: - Public Methods

    /// Set the API key to make API Queries.
    ///
    /// An API Key can be obtained from [here](https://www.pexels.com/api/)
    /// - Attention: The `apiKey` must not be empty!
    /// - Parameters:
    ///   - apiKey: The API Key.
    ///   - logLevel: The `logLevel` to use. Defaults to ``PSLogLevel/info``.
    public func setup(apiKey: String, logLevel: PSLogLevel = .info) {
        self.apiKey = apiKey
        self.logger.setLogLevel(logLevel)
        logger.log("Setup Pexels-Swift complete")
    }

    /// Holds the most recent values for Rate Limit statistics.
    ///
    /// See <doc:Rate-Limits> for more information.
    public private(set) var rateLimit: RateLimit = .init()

    // MARK: - Internal Methods

    // MARK: Fetch Photos

    /// Fetch ``PSPhoto`` from [`URL`](https://developer.apple.com/documentation/foundation/url)
    /// - Parameter url: The URL to fetch from.
    /// - Returns: A result type of ``PhotosResult``
    internal func fetchPhotos(url: URL) async -> PhotosResult {
        let result: PSResult<ContentResults<PSPhoto>> = await fetch(url: url)
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let (wrapper, response)):
            let metaData = PSPagingInfo(
                page: wrapper.page,
                perPage: wrapper.perPage,
                totalResults: wrapper.totalResults,
                previousPage: wrapper.previousPage,
                nextPage: wrapper.nextPage
            )
            if let photos = wrapper.photos {
                return .success((photos, metaData, response))
            } else if let media = wrapper.media {
                return .success((media, metaData, response))
            } else {
                return .failure(.noContent)
            }
        }
    }

    // MARK: Fetch Videos

    /// Fetch ``PSVideo`` from [`URL`](https://developer.apple.com/documentation/foundation/url)
    /// - Parameter url: The URL to fetch from.
    /// - Returns: A result type of ``VideosResult``
    internal func fetchVideos(url: URL) async -> VideosResult {
        let result: PSResult<ContentResults<PSVideo>> = await fetch(url: url)
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let (wrapper, response)):
            let metaData = PSPagingInfo(
                page: wrapper.page,
                perPage: wrapper.perPage,
                totalResults: wrapper.totalResults,
                previousPage: wrapper.previousPage,
                nextPage: wrapper.nextPage
            )
            if let videos = wrapper.videos {
                return .success((videos, metaData, response))
            } else if let media = wrapper.media {
                return .success((media, metaData, response))
            } else {
                return .failure(.noContent)
            }
        }
    }

    // MARK: Fetch Generic Type

    /// Fetch generic type `<T>` from [`URL`](https://developer.apple.com/documentation/foundation/url)
    /// - Parameter url: The URL to fetch from.
    /// - Returns: A result type of ``PSResult``.
    internal func fetch<T: Codable>(url: URL) async -> PSResult<T> {
        logger.log("Start fetching from URL: \(url.absoluteString)")
        guard !apiKey.isEmpty else {
            logger.logError(.noAPIKey)
            return .failure(.noAPIKey)
        }
        var req = URLRequest(url: url)
        req.setValue(apiKey, forHTTPHeaderField: apiHeader)
        do {
            var data: Data
            var response: URLResponse
            if #available(macOS 12.0, iOS 15.0, *) {
                (data, response) = try await urlSession.data(for: req)
            } else { // async/await compatibility for iOS 13 & macOS 10.15
                (data, response) = try await urlSession._data(for: req)
            }

            guard let response = response as? HTTPURLResponse else {
                logger.logError(.noResponse(req.debugDescription))
                return .failure(.noResponse(req.debugDescription))
            }

            logger.logResponse(response)
            saveRateLimits(for: response)

            guard (200...299).contains(response.statusCode) else {
                logger.logError(.httpResponse(response.statusCode))
                return .failure(.httpResponse(response.statusCode))
            }

            logger.logData(data)

            let result = try JSONDecoder().decode(T.self, from: data)
            return .success((result, response))

        } catch {
            logger.logError(.generic(error.localizedDescription))
            return .failure(.generic(error.localizedDescription))
        }
    }

    /// Saves the rate limit data of a given
    /// [`HTTPURLResponse`](https://developer.apple.com/documentation/foundation/httpurlresponse) to
    /// ``PexelsSwift/PexelsSwift/rateLimit-swift.property``, if possible
    /// - Parameter response: The response to fetch the rate limit data from
    private func saveRateLimits(for response: HTTPURLResponse) {
        guard let limit = response.pexelsLimit,
              let remaining = response.pexelsRemaining,
              let reset = response.pexelsReset
        else { return }

        self.rateLimit = .init(
            limit: limit,
            remaining: remaining,
            reset: reset
        )
    }
}
