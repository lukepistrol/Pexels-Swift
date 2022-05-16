//
//  PexelsSwift+Videos.swift
//  
//
//  Created by Lukas Pistrol on 16.05.22.
//

import Foundation

public extension PexelsSwift {

    private typealias P = PSQueryParameter

    // MARK: Get Video

    /// Gets a single ``PSVideo`` based on a given ID
    ///
    /// If the request fails this will return `nil`
    /// - Parameter id: The ID of the Video
    /// - Returns: A result type of ``VideoResult``
    func getVideo(by id: Int) async -> VideoResult {
        guard !apiKey.isEmpty else { return .failure(.noAPIKey) }
        guard let url = URL(string: API.videoByID)?.appendingPathComponent(id.string)
        else { return .failure(.badURL) }
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
    ///   - count: The number of results a page should contain. Defaults to `10`
    /// - Returns: A result type of ``VideosResult``
    func getPopularVideos(
        minimumWidth: Int? = nil,
        minimumHeight: Int? = nil,
        minimumDuration: Int? = nil,
        maximumDuration: Int? = nil,
        page: Int = 1,
        count: Int = 10
    ) async -> VideosResult {
        guard var components: URLComponents = .init(string: API.popularVideos)
        else { return .failure(.badURL) }
        var param: Array<URLQueryItem> = [.init(name: P.page, value: page.string),
                                          .init(name: P.perPage, value: count.string)]
        if let minimumWidth = minimumWidth {
            param.append(.init(name: P.minWidth, value: minimumWidth.string))
        }
        if let minimumHeight = minimumHeight {
            param.append(.init(name: P.minHeight, value: minimumHeight.string))
        }
        if let minimumDuration = minimumDuration {
            param.append(.init(name: P.minDuration, value: minimumDuration.string))
        }
        if let maximumDuration = maximumDuration {
            param.append(.init(name: P.maxDuration, value: maximumDuration.string))
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
    ///   - count: The number of results a page should contain. Defaults to `10`
    ///   - completion: A result type of ``VideosResult``
    func getPopularVideos(
        minimumWidth: Int? = nil,
        minimumHeight: Int? = nil,
        minimumDuration: Int? = nil,
        maximumDuration: Int? = nil,
        page: Int = 1,
        count: Int = 10,
        completion: @escaping (VideosResult) -> Void
    ) {
        Task {
            completion(await getPopularVideos(
                minimumWidth: minimumWidth,
                minimumHeight: minimumHeight,
                minimumDuration: minimumDuration,
                maximumDuration: maximumDuration,
                page: page,
                count: count
            ))
        }
    }

    // MARK: Search Videos

    /// Get a list of ``PSVideo`` based on a search query
    /// - Parameters:
    ///   - query: The search query.
    ///   - orientation: Desired video orientation. Defaults to `nil`
    ///   - size: Minimum video size. Defaults to `nil`
    ///   - locale: The Locale. Defaults to `nil`
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - count: The number of results a page should contain. Defaults to `10`
    /// - Returns: A result type of ``VideosResult``
    func searchVideos(
        _ query: String,
        orientation: PSOrientation? = nil,
        size: PSSize? = nil,
        locale: PSLocale? = nil,
        page: Int = 1,
        count: Int = 10
    ) async -> VideosResult {
        guard var components: URLComponents = .init(string: API.searchVideos)
        else { return .failure(.badURL) }
        var param: Array<URLQueryItem> = [.init(name: P.query, value: query),
                                          .init(name: P.page, value: page.string),
                                          .init(name: P.perPage, value: count.string)]
        if let orientation = orientation {
            param.append(.init(name: P.orientation, value: orientation.rawValue))
        }
        if let size = size {
            param.append(.init(name: P.size, value: size.rawValue))
        }
        if let locale = locale {
            param.append(.init(name: P.locale, value: locale.rawValue))
        }

        components.queryItems = param
        guard let url = components.url else { return .failure(.badURL) }
        return await fetchVideos(url: url)
    }

    /// Get a list of ``PSVideo`` based on a search query
    /// - Parameters:
    ///   - query: The search query.
    ///   - orientation: Desired video orientation. Defaults to `nil`
    ///   - size: Minimum video size. Defaults to `nil`
    ///   - locale: The Locale. Defaults to `nil`
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - count: The number of results a page should contain. Defaults to `10`
    ///   - completion: A result type of ``VideosResult``
    func searchVideos(
        _ query: String,
        orientation: PSOrientation? = nil,
        size: PSSize? = nil,
        locale: PSLocale? = nil,
        page: Int = 1,
        count: Int = 10,
        completion: @escaping (VideosResult) -> Void
    ) {
        Task {
            completion(await searchVideos(
                query,
                orientation: orientation,
                size: size,
                locale: locale,
                page: page,
                count: count
            ))
        }
    }

    // MARK: Get Videos for Category ID

    /// Get a list of ``PSVideo`` based on a gived category ID
    /// - Parameters:
    ///   - categoryID: The category ID
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - count: The number of results a page should contain. Defaults to `10`
    /// - Returns: A result type of ``VideosResult``
    func getVideos(
        for categoryID: String,
        page: Int = 1,
        count: Int = 10
    ) async -> VideosResult {
        guard var components: URLComponents = .init(string: API.collections(categoryID))
        else { return .failure(.badURL) }
        let param: Array<URLQueryItem> = [.init(name: P.type, value: "videos"),
                                          .init(name: P.page, value: page.string),
                                          .init(name: P.perPage, value: count.string)]

        components.queryItems = param
        guard let url = components.url else { return .failure(.badURL) }
        return await fetchVideos(url: url)
    }

    /// Get a list of ``PSVideo`` based on a gived category ID
    /// - Parameters:
    ///   - categoryID: The category ID
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - count: The number of results a page should contain. Defaults to `10`
    ///   - completion: A result type of ``VideosResult``
    func getVideos(
        for categoryID: String,
        page: Int = 1,
        count: Int = 10,
        completion: @escaping (VideosResult) -> Void
    ) {
        Task {
            completion(await getVideos(for: categoryID, page: page, count: count))
        }
    }

}
