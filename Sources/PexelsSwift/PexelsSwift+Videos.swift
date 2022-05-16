//
//  PexelsSwift+Videos.swift
//  
//
//  Created by Lukas Pistrol on 16.05.22.
//

import Foundation

public extension PexelsSwift {

    // MARK: Get Video

    /// Gets a single ``PSVideo`` based on a given ID
    ///
    /// If the request fails this will return `nil`
    /// - Parameter id: The ID of the Video
    /// - Returns: A result type of ``VideoResult``
    func getVideo(by id: Int) async -> VideoResult {
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
    func getVideo(by id: Int, completion: @escaping (VideoResult) -> Void) {
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
    func getPopularVideos(
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
    func getPopularVideos(
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
    func searchVideos(
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
    func searchVideos(
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
    func getVideos(
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
    func getVideos(
        for categoryID: String,
        page: Int = 1,
        count results: Int = 10,
        completion: @escaping (VideosResult) -> Void
    ) {
        Task {
            completion(await getVideos(for: categoryID, page: page, count: results))
        }
    }

}
