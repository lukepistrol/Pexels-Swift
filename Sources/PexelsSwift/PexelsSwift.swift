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

    /// Result type for an array of ``PSVideo``.
    public typealias VideosResult = Result<Array<PSVideo>, PSError>

    /// Result type for a single ``PSVideo``.
    public typealias VideoResult = Result<PSVideo, PSError>

    /// Result type for an array of ``PSPhoto``.
    public typealias PhotosResult = Result<Array<PSPhoto>, PSError>

    /// Result type for a single ``PSPhoto``.
    public typealias PhotoResult = Result<PSPhoto, PSError>

    /// Result type for an array of ``PSCollection``.
    public typealias CollectionResult = Result<Array<PSCollection>, PSError>

    /// Result type for a type of **T**.
    private typealias PSResult<T> = Result<T, PSError>
    

    /// The singleton instance of ``PexelsSwift``
    public static let shared: PexelsSwift = .init()

    /// The HTTP-Header field for the API Key
    private let apiHeader: String = "Authorization"

    /// The API key
    ///
    /// Set through ``setAPIKey(_:)``.
    private var apiKey: String = ""

    /// An instance of ``PSLogger``
    private var logger: PSLogger = .init()

    // MARK: - Public Methods

    /// Set the API key to make API Queries.
    ///
    /// An API Key can be obtained from [here](https://www.pexels.com/api/)
    /// - Parameter apiKey: The API Key
    /// - Parameter logLevel: The `logLevel` to use. Defaults to ``PSLogLevel/info``.
    public func setup(apiKey: String, logLevel: PSLogLevel = .info) {
        self.apiKey = apiKey
        self.logger.setLogLevel(logLevel)
    }

    // MARK: Get Collections

    /// Get a list of ``PSCollection``
    /// - Parameters:
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: A result type of ``CollectionResult``
    public func getCollections(
        page: Int = 1,
        count results: Int = 10
    ) async -> CollectionResult {
        guard !apiKey.isEmpty else { return .failure(.noAPIKey) }
        let url = URL(string: "https://api.pexels.com/v1/collections/featured?page=\(page)&per_page=\(results)")!

        let result: Result<CollectionResults, PSError> = await fetch(url: url)
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let wrapper): return .success(wrapper.collections)
        }
    }

    /// Get a list of ``PSCollection``
    /// - Parameters:
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    ///   - completion: A result type of ``CollectionResult``
    public func getCollections(
        page: Int = 1,
        count results: Int = 10,
        completion: @escaping (CollectionResult) -> Void
    ) {
        Task {
            completion(await getCollections(page: page, count: results))
        }
    }

    // MARK: Get Photo

    /// Gets a single ``PSPhoto`` based on a given ID
    ///
    /// If the request fails this will return `nil`
    /// - Parameter id: The ID of the Photo
    /// - Returns: A result type of ``PhotoResult``
    public func getPhoto(by id: Int) async -> PhotoResult {
        guard !apiKey.isEmpty else { return .failure(.noAPIKey) }
        let url = URL(string: API.photoByID + "/\(id)")!

        let result: Result<PSPhoto, PSError> = await fetch(url: url)
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let photo): return .success(photo)
        }
    }

    /// Gets a single ``PSPhoto`` based on a given ID
    ///
    /// If the request fails this will return `nil`
    /// - Parameters:
    ///   - id: The ID of the Photo
    ///   - completion: A result type of ``PhotoResult``
    public func getPhoto(by id: Int, completion: @escaping (PhotoResult) -> Void) {
        Task {
            completion(await getPhoto(by: id))
        }
    }

    // MARK: Get Curated Photos

    /// Get a list of curated ``PSPhoto``
    /// - Parameters:
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: A result type of ``PhotosResult``
    public func getCuratedPhotos(
        page: Int = 1,
        count results: Int = 10
    ) async -> PhotosResult {
        var components: URLComponents = .init(string: API.curatedPhotos)!
        let param: Array<URLQueryItem> = [.init(name: "page", value: "\(page)"),
                                          .init(name: "per_page", value: "\(results)")]

        components.queryItems = param
        guard let url = components.url else { return .failure(.badURL) }
        return await fetchPhotos(url: url)
    }

    /// Get a list of curated ``PSPhoto``
    /// - Parameters:
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    ///   - completion: A result type of ``PhotosResult``
    public func getCuratedPhotos(
        page: Int = 1,
        count results: Int = 10,
        completion: @escaping (PhotosResult) -> Void
    ) {
        Task {
            completion(await getCuratedPhotos(page: page, count: results))
        }
    }

    // MARK: Search Photos

    /// Get a list of ``PSPhoto`` based on a search query
    /// - Parameters:
    ///   - query: The search query.
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    ///   - orientation: The orientation. Defaults to `nil`
    ///   - size: The minimum size. Defaults to `nil`
    ///   - color: The color. Defaults to `nil`
    /// - Returns: A result type of ``PhotosResult``
    public func searchPhotos(
        _ query: String,
        orientation: PSOrientation? = nil,
        size: PSSize? = nil,
        color: PSColor? = nil,
        page: Int = 1,
        count results: Int = 10
    ) async -> PhotosResult {
        var components: URLComponents = .init(string: API.searchPhotos)!
        var param: Array<URLQueryItem> = [.init(name: "query", value: query),
                                          .init(name: "page", value: "\(page)"),
                                          .init(name: "per_page", value: "\(results)")]

        if let orientation = orientation {
            param.append(.init(name: "orientation", value: orientation.rawValue))
        }
        if let size = size {
            param.append(.init(name: "size", value: size.rawValue))
        }
        if let color = color {
            param.append(.init(name: "color", value: color.rawValue))
        }

        components.queryItems = param
        guard let url = components.url else { return .failure(.badURL) }
        return await fetchPhotos(url: url)
    }

    /// Get a list of ``PSPhoto`` based on a search query
    /// - Parameters:
    ///   - query: The search query.
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    ///   - orientation: The orientation. Defaults to `nil`
    ///   - size: The minimum size. Defaults to `nil`
    ///   - color: The color. Defaults to `nil`
    ///   - completion: A result type of ``PhotosResult``
    public func searchPhotos(
        _ query: String,
        orientation: PSOrientation? = nil,
        size: PSSize? = nil,
        color: PSColor? = nil,
        page: Int = 1,
        count results: Int = 10,
        completion: @escaping (PhotosResult) -> Void
    ) {
        Task {
            completion(await searchPhotos(
                query, orientation: orientation, size: size, color: color, page: page, count: results
            ))
        }
    }

    // MARK: Get Photos for Category ID

    /// Get a list of ``PSPhoto`` based on a gived category ID
    /// - Parameters:
    ///   - categoryID: The category ID
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: A result type of ``PhotosResult``
    public func getPhotos(
        for categoryID: String,
        page: Int = 1,
        count results: Int = 10
    ) async -> PhotosResult {
        var components: URLComponents = .init(string: API.collections + "/\(categoryID)")!
        let param: Array<URLQueryItem> = [.init(name: "type", value: "photos"),
                                          .init(name: "page", value: "\(page)"),
                                          .init(name: "per_page", value: "\(results)")]

        components.queryItems = param
        guard let url = components.url else { return .failure(.badURL) }
        return await fetchPhotos(url: url)
    }

    /// Get a list of ``PSPhoto`` based on a gived category ID
    /// - Parameters:
    ///   - categoryID: The category ID
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    ///   - completion: A result type of ``PhotosResult``
    public func getPhotos(
        for categoryID: String,
        page: Int = 1,
        count results: Int = 10,
        completion: @escaping (PhotosResult) -> Void
    ) {
        Task {
            completion(await getPhotos(for: categoryID, page: page, count: results))
        }
    }

    // MARK: Get Video

    /// Gets a single ``PSVideo`` based on a given ID
    ///
    /// If the request fails this will return `nil`
    /// - Parameter id: The ID of the Video
    /// - Returns: A result type of ``VideoResult``
    public func getVideo(by id: Int) async -> VideoResult {
        guard !apiKey.isEmpty else { return .failure(.noAPIKey) }
        let url = URL(string: API.videoByID + "/\(id)")!
        let result: Result<PSVideo, PSError> = await fetch(url: url)
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let video): return .success(video)
        }
    }

    /// Gets a single ``PSVideo`` based on a given ID
    ///
    /// If the request fails this will return `nil`
    /// - Parameters:
    ///   - id: The ID of the Video
    ///   - completion: A result type of ``VideoResult``
    public func getVideo(by id: Int, completion: @escaping (VideoResult) -> Void) {
        Task {
            completion(await getVideo(by: id))
        }
    }

    // MARK: Get Popular Videos

    /// Get a list of popular videos
    /// - Parameters:
    ///   - minimumWidth: The minimum width in pixels of the returned videos.
    ///   - minimumHeight: The minimum height in pixels of the returned videos.
    ///   - minimumDuration: The minimum duration in seconds of the returned videos.
    ///   - maximumDuration: The maximum duration in seconds of the returned videos.
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: A result type of ``VideosResult``
    public func getPopularVideos(
        minimumWidth: Int? = nil,
        minimumHeight: Int? = nil,
        minimumDuration: Int? = nil,
        maximumDuration: Int? = nil,
        page: Int = 1,
        count results: Int = 10
    ) async -> VideosResult {
        var components: URLComponents = .init(string: API.popularVideos)!
        var param: Array<URLQueryItem> = [.init(name: "page", value: "\(page)"),
                                          .init(name: "per_page", value: "\(results)")]
        if let minimumWidth = minimumWidth {
            param.append(.init(name: "min_width", value: "\(minimumWidth)"))
        }
        if let minimumHeight = minimumHeight {
            param.append(.init(name: "min_height", value: "\(minimumHeight)"))
        }
        if let minimumDuration = minimumDuration {
            param.append(.init(name: "min_duration", value: "\(minimumDuration)"))
        }
        if let maximumDuration = maximumDuration {
            param.append(.init(name: "max_duration", value: "\(maximumDuration)"))
        }

        components.queryItems = param
        guard let url = components.url else { return .failure(.badURL) }
        return await fetchVideos(url: url)
    }

    /// Get a list of popular videos
    /// - Parameters:
    ///   - minimumWidth: The minimum width in pixels of the returned videos.
    ///   - minimumHeight: The minimum height in pixels of the returned videos.
    ///   - minimumDuration: The minimum duration in seconds of the returned videos.
    ///   - maximumDuration: The maximum duration in seconds of the returned videos.
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    ///   - completion: A result type of ``VideosResult``
    public func getPopularVideos(
        minimumWidth: Int? = nil,
        minimumHeight: Int? = nil,
        minimumDuration: Int? = nil,
        maximumDuration: Int? = nil,
        page: Int = 1,
        count results: Int = 10,
        completion: @escaping (VideosResult) -> Void
    ) {
        Task {
            completion(await getPopularVideos(
                minimumWidth: minimumWidth,
                minimumHeight: minimumHeight,
                minimumDuration: minimumDuration,
                maximumDuration: maximumDuration,
                page: page,
                count: results
            ))
        }
    }

    // MARK: Search Videos

    /// Get a list of ``PSVideo`` based on a search query
    /// - Parameters:
    ///   - query: The search query.
    ///   - orientation: Desired video orientation.
    ///   - size: Minimum video size.
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: A result type of ``VideosResult``
    public func searchVideos(
        _ query: String,
        orientation: PSOrientation? = nil,
        size: PSSize? = nil,
        page: Int = 1,
        results: Int = 10
    ) async -> VideosResult {
        var components: URLComponents = .init(string: API.searchVideos)!
        var param: Array<URLQueryItem> = [.init(name: "query", value: query),
                                          .init(name: "page", value: "\(page)"),
                                          .init(name: "per_page", value: "\(results)")]
        if let orientation = orientation {
            param.append(.init(name: "orientation", value: orientation.rawValue))
        }
        if let size = size {
            param.append(.init(name: "size", value: size.rawValue))
        }

        components.queryItems = param
        guard let url = components.url else { return .failure(.badURL) }
        return await fetchVideos(url: url)
    }

    /// Get a list of ``PSVideo`` based on a search query
    /// - Parameters:
    ///   - query: The search query.
    ///   - orientation: Desired video orientation.
    ///   - size: Minimum video size.
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    ///   - completion: A result type of ``VideosResult``
    public func searchVideos(
        _ query: String,
        orientation: PSOrientation? = nil,
        size: PSSize? = nil,
        page: Int = 1,
        results: Int = 10,
        completion: @escaping (VideosResult) -> Void
    ) {
        Task {
            completion(await searchVideos(
                query,
                orientation: orientation,
                size: size,
                page: page,
                results: results
            ))
        }
    }

    // MARK: Get Videos for Category ID

    /// Get a list of ``PSVideo`` based on a gived category ID
    /// - Parameters:
    ///   - categoryID: The category ID
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: A result type of ``VideosResult``
    public func getVideos(
        for categoryID: String,
        page: Int = 1,
        count results: Int = 10
    ) async -> VideosResult {
        var components: URLComponents = .init(string: API.collections + "/\(categoryID)")!
        let param: Array<URLQueryItem> = [.init(name: "type", value: "videos"),
                                          .init(name: "page", value: "\(page)"),
                                          .init(name: "per_page", value: "\(results)")]

        components.queryItems = param
        guard let url = components.url else { return .failure(.badURL) }
        return await fetchVideos(url: url)
    }

    /// Get a list of ``PSVideo`` based on a gived category ID
    /// - Parameters:
    ///   - categoryID: The category ID
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    ///   - completion: A result type of ``VideosResult``
    public func getVideos(
        for categoryID: String,
        page: Int = 1,
        count results: Int = 10,
        completion: @escaping (VideosResult) -> Void
    ) {
        Task {
            completion(await getVideos(for: categoryID, page: page, count: results))
        }
    }

    // MARK: - Private Methods

    // MARK: Fetch Photos

    /// Fetch ``PSPhoto`` from [`URL`](https://developer.apple.com/documentation/foundation/url)
    /// - Parameter url: The URL to fetch from.
    /// - Returns: A result type of ``PhotosResult``
    private func fetchPhotos(url: URL) async -> PhotosResult {
        let result: Result<ContentResults<PSPhoto>, PSError> = await fetch(url: url)
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let wrapper):
            if let photos = wrapper.photos {
                return .success(photos)
            } else if let media = wrapper.media {
                return .success(media)
            } else {
                return .failure(.noContent)
            }
        }
    }

    // MARK: Fetch Videos

    /// Fetch ``PSVideo`` from [`URL`](https://developer.apple.com/documentation/foundation/url)
    /// - Parameter url: The URL to fetch from.
    /// - Returns: A result type of ``VideosResult``
    private func fetchVideos(url: URL) async -> VideosResult {
        let result: Result<ContentResults<PSVideo>, PSError> = await fetch(url: url)
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let wrapper):
            if let videos = wrapper.videos {
                return .success(videos)
            } else if let media = wrapper.media {
                return .success(media)
            } else {
                return .failure(.noContent)
            }
        }
    }

    // MARK: Fetch Generic Type

    /// Fetch **T** from [`URL`](https://developer.apple.com/documentation/foundation/url)
    /// - Parameter url: The URL to fetch from.
    /// - Returns: A result type of ``PSResult``.
    private func fetch<T: Codable>(url: URL) async -> PSResult<T> {
        guard !apiKey.isEmpty else {
            logger.logError(.noAPIKey)
            return .failure(.noAPIKey)
        }
        var req = URLRequest(url: url)
        req.setValue(apiKey, forHTTPHeaderField: apiHeader)
        do {
            let (data, response) = try await URLSession.shared.data(for: req)

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
