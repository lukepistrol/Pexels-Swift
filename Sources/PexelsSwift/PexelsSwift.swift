//
//  PexelsSwift.swift
//
//
//  Created by Lukas Pistrol on 14.05.22.
//

import Foundation
import Combine

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

    /// Result type for an array of ``PSCollectionCategory``.
    public typealias CollectionResult = Result<Array<PSCollectionCategory>, PSError>
    

    /// The singleton instance of ``PexelsSwift``
    public static let shared: PexelsSwift = .init()

    /// The HTTP-Header field for the API Key
    private let apiHeader: String = "Authorization"

    /// The API key
    ///
    /// Set through ``setAPIKey(_:)``.
    private var apiKey: String = ""

    // MARK: - Public Methods

    /// Set the API key to make API Queries.
    ///
    /// An API Key can be obtained from [here](https://www.pexels.com/api/)
    /// - Parameter key: The API Key
    public func setAPIKey(_ key: String) {
        self.apiKey = key
    }

    // MARK: Collections

    /// Get a list of ``PSCollectionCategory``
    /// - Parameters:
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: A result type of ``CollectionResult``
    public func getCollections(
        page: Int = 1,
        count results: Int = 10
    ) async -> CollectionResult {
        guard !apiKey.isEmpty else { return .failure(.noAPIKey) }
        var req = URLRequest(url: URL(string: "https://api.pexels.com/v1/collections/featured?page=\(page)&per_page=\(results)")!)
        req.setValue(apiKey, forHTTPHeaderField: apiHeader)

        return await withCheckedContinuation { continuation in
            cancelable = URLSession.shared.dataTaskPublisher(for: req)
                .subscribe(on: Self.sessionProcessingQueue)
                .map({ return $0.data })
                .decode(type: CollectionResults.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { subCompletion in
                    switch subCompletion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(
                            returning: .failure(.generic(error.localizedDescription))
                        )
                    }
                }, receiveValue: { (wrapper) in
                    continuation.resume(returning: .success(wrapper.collections))
                })
        }
    }

    // MARK: Photos

    /// Gets a single ``PSPhoto`` based on a given ID
    ///
    /// If the request fails this will return `nil`
    /// - Parameter id: The ID of the Photo
    /// - Returns: A result type of ``PhotoResult``
    public func getPhoto(by id: Int) async -> PhotoResult {
        guard !apiKey.isEmpty else { return .failure(.noAPIKey) }
        let url = URL(string: API.photoByID + "/\(id)")!
        var req = URLRequest(url: url)
        req.setValue(apiKey, forHTTPHeaderField: apiHeader)

        return await withCheckedContinuation { continuation in
            cancelable = URLSession.shared.dataTaskPublisher(for: req)
                .subscribe(on: Self.sessionProcessingQueue)
                .map({ $0.data })
                .decode(type: PSPhoto.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(returning: .failure(.generic(error.localizedDescription)))
                    }
                }, receiveValue: { photo in
                    continuation.resume(returning: .success(photo))
                })
        }
    }

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

    /// Get a list of ``PSPhoto`` based on a search query
    /// - Parameters:
    ///   - query: The search query.
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
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

    // MARK: Videos

    /// Gets a single ``PSVideo`` based on a given ID
    ///
    /// If the request fails this will return `nil`
    /// - Parameter id: The ID of the Video
    /// - Returns: A result type of ``VideoResult``
    public func getVideo(by id: Int) async -> VideoResult {
        guard !apiKey.isEmpty else { return .failure(.noAPIKey) }
        let url = URL(string: API.videoByID + "/\(id)")!
        var req = URLRequest(url: url)
        req.setValue(apiKey, forHTTPHeaderField: apiHeader)

        return await withCheckedContinuation { continuation in
            cancelable = URLSession.shared.dataTaskPublisher(for: req)
                .subscribe(on: Self.sessionProcessingQueue)
                .map({ $0.data })
                .decode(type: PSVideo.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(returning: .failure(.generic(error.localizedDescription)))
                    }
                }, receiveValue: { video in
                    continuation.resume(returning: .success(video))
                })
        }
    }

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

    // MARK: - Private Methods

    private var cancelable: AnyCancellable?

    private static let sessionProcessingQueue = DispatchQueue(label: "SessionProcessingQueue")

    /// Fetch ``PSPhoto`` from [`URL`](https://developer.apple.com/documentation/foundation/url)
    /// - Parameter url: The URL to fetch from.
    /// - Returns: A result type of ``PhotosResult``
    private func fetchPhotos(url: URL) async -> PhotosResult {
        guard !apiKey.isEmpty else { return .failure(.noAPIKey) }
        var req = URLRequest(url: url)
        req.setValue(apiKey, forHTTPHeaderField: apiHeader)

        return await withCheckedContinuation { continuation in
            cancelable = URLSession.shared.dataTaskPublisher(for: req)
                .subscribe(on: Self.sessionProcessingQueue)
                .map({ return $0.data })
                .decode(type: ContentResults<PSPhoto>.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(returning: .failure(.generic(error.localizedDescription)))
                    }
                }, receiveValue: { wrapper in
                    if let photos = wrapper.photos {
                        continuation.resume(returning: .success(photos))
                    } else if let media = wrapper.media {
                        continuation.resume(returning: .success(media))
                    } else {
                        continuation.resume(returning: .failure(.noContent))
                    }
                })
        }
    }

    /// Fetch ``PSVideo`` from [`URL`](https://developer.apple.com/documentation/foundation/url)
    /// - Parameter url: The URL to fetch from.
    /// - Returns: A result type of ``VideosResult``
    private func fetchVideos(url: URL) async -> VideosResult {
        guard !apiKey.isEmpty else { return .failure(.noAPIKey) }
        var req = URLRequest(url: url)
        req.setValue(apiKey, forHTTPHeaderField: apiHeader)

        return await withCheckedContinuation { continuation in
            cancelable = URLSession.shared.dataTaskPublisher(for: req)
                .subscribe(on: Self.sessionProcessingQueue)
                .map({ $0.data })
                .decode(type: ContentResults<PSVideo>.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(returning: .failure(.generic(error.localizedDescription)))
                    }
                }, receiveValue: { wrapper in
                    if let videos = wrapper.videos {
                        continuation.resume(returning: .success(videos))
                    } else if let media = wrapper.media {
                        continuation.resume(returning: .success(media))
                    } else {
                        continuation.resume(returning: .failure(.noContent))
                    }
                })
        }
    }
}
