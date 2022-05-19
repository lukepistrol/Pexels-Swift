//
//  PexelsSwift.swift
//
//
//  Created by Lukas Pistrol on 14.05.22.
//

import Foundation

/// A singleton class for making API calls.
public class PexelsSwift {

    internal init() {}

    public typealias CategoryID = String

    /// Result type for an array of ``PSVideo``.
    public typealias VideosResult = Result<(content: Array<PSVideo>, metadata: PSMetaData), PSError>

    /// Result type for a single ``PSVideo``.
    public typealias VideoResult = Result<PSVideo, PSError>

    /// Result type for an array of ``PSPhoto``.
    public typealias PhotosResult = Result<(content: Array<PSPhoto>, metadata: PSMetaData), PSError>

    /// Result type for a single ``PSPhoto``.
    public typealias PhotoResult = Result<PSPhoto, PSError>

    /// Result type for an array of ``PSCollection``.
    public typealias CollectionResult = Result<(content: Array<PSCollection>, metadata: PSMetaData), PSError>

    /// Result type for a generic type of `<T>`.
    internal typealias PSResult<T> = Result<T, PSError>
    

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

    // MARK: - Internal Methods

    // MARK: Fetch Photos

    /// Fetch ``PSPhoto`` from [`URL`](https://developer.apple.com/documentation/foundation/url)
    /// - Parameter url: The URL to fetch from.
    /// - Returns: A result type of ``PhotosResult``
    internal func fetchPhotos(url: URL) async -> PhotosResult {
        let result: Result<ContentResults<PSPhoto>, PSError> = await fetch(url: url)
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let wrapper):
            let metaData = PSMetaData(
                page: wrapper.page,
                perPage: wrapper.perPage,
                totalResults: wrapper.totalResults,
                previousPage: wrapper.previousPage,
                nextPage: wrapper.nextPage
            )
            if let photos = wrapper.photos {
                return .success((photos, metaData))
            } else if let media = wrapper.media {
                return .success((media, metaData))
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
        let result: Result<ContentResults<PSVideo>, PSError> = await fetch(url: url)
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let wrapper):
            let metaData = PSMetaData(
                page: wrapper.page,
                perPage: wrapper.perPage,
                totalResults: wrapper.totalResults,
                previousPage: wrapper.previousPage,
                nextPage: wrapper.nextPage
            )
            if let videos = wrapper.videos {
                return .success((videos, metaData))
            } else if let media = wrapper.media {
                return .success((media, metaData))
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
                (data, response) = try await URLSession.shared.data(for: req)
            } else { // async/await compatibility for iOS 13 & macOS 10.15
                (data, response) = try await URLSession.shared._data(for: req)
            }

            guard let response = response as? HTTPURLResponse else {
                logger.logError(.noResponse)
                return .failure(.noResponse)
            }

            logger.logResponse(response)

            guard (200...299).contains(response.statusCode) else {
                logger.logError(.httpResponse(response.statusCode))
                return .failure(.httpResponse(response.statusCode))
            }

            logger.logData(data)

            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)

        } catch {
            logger.logError(.generic(error.localizedDescription))
            return .failure(.generic(error.localizedDescription))
        }
    }
}
