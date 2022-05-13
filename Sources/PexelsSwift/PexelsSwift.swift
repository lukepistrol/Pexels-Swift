import Foundation
import Combine

/// A singleton class for making API calls.
public class PexelsSwift {

    internal init() {}

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
    /// - Returns: An array of ``PSCollectionCategory``
    public func getCategories(
        page: Int = 1,
        count results: Int = 10
    ) async -> Array<PSCollectionCategory> {
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
                    case .failure(_):
                        continuation.resume(returning: [])
                    }
                }, receiveValue: { (wrapper) in
                    continuation.resume(returning: wrapper.collections)
                })
        }
    }

    // MARK: Photos

    /// Gets a single ``PSPhoto`` based on a given ID
    ///
    /// If the request fails this will return `nil`
    /// - Parameter id: The ID of the Photo
    /// - Returns: A ``PSPhoto`` or `nil`
    public func getPhoto(by id: Int) async -> PSPhoto? {
        let url = URL(string: PSURL.photoByID + "/\(id)")!
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
                    case .failure(_):
                        continuation.resume(returning: nil)
                    }
                }, receiveValue: { photo in
                    continuation.resume(returning: photo)
                })
        }
    }

    /// Get a list of curated ``PSPhoto``
    /// - Parameters:
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: An array of ``PSPhoto``
    public func getCuratedPhotos(
        page: Int = 1,
        count results: Int = 10
    ) async -> Array<PSPhoto> {
        var components: URLComponents = .init(string: PSURL.curatedPhotos)!
        let param: Array<URLQueryItem> = [.init(name: "page", value: "\(page)"),
                                          .init(name: "per_page", value: "\(results)")]

        components.queryItems = param
        guard let url = components.url else { return [] }
        return await fetchPhotos(url: url)
    }

    /// Get a list of ``PSPhoto`` based on a search query
    /// - Parameters:
    ///   - query: The search query.
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: An array of ``PSPhoto``
    public func searchPhotos(
        _ query: String,
        orientation: PSOrientation? = nil,
        size: PSSize? = nil,
        color: PSColor? = nil,
        page: Int = 1,
        count results: Int = 10
    ) async -> Array<PSPhoto> {
        var components: URLComponents = .init(string: PSURL.searchPhotos)!
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
        guard let url = components.url else { return [] }
        return await fetchPhotos(url: url)
    }

    /// Get a list of ``PSPhoto`` based on a gived category ID
    /// - Parameters:
    ///   - categoryID: The category ID
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: An array of ``PSPhoto``
    public func getPhotos(
        for categoryID: String,
        page: Int = 1,
        count results: Int = 10
    ) async -> Array<PSPhoto> {
        var components: URLComponents = .init(string: PSURL.collections + "/\(categoryID)")!
        let param: Array<URLQueryItem> = [.init(name: "type", value: "photos"),
                                          .init(name: "page", value: "\(page)"),
                                          .init(name: "per_page", value: "\(results)")]

        components.queryItems = param
        guard let url = components.url else { return [] }
        return await fetchPhotos(url: url)
    }

    // MARK: Videos

    /// Gets a single ``PSVideo`` based on a given ID
    ///
    /// If the request fails this will return `nil`
    /// - Parameter id: The ID of the Video
    /// - Returns: A ``PSVideo`` or `nil`
    public func getVideo(by id: Int) async -> PSVideo? {
        let url = URL(string: PSURL.videoByID + "/\(id)")!
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
                    case .failure(_):
                        continuation.resume(returning: nil)
                    }
                }, receiveValue: { video in
                    continuation.resume(returning: video)
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
    /// - Returns: An array of ``PSVideo``
    public func getPopularVideos(
        minimumWidth: Int? = nil,
        minimumHeight: Int? = nil,
        minimumDuration: Int? = nil,
        maximumDuration: Int? = nil,
        page: Int = 1,
        count results: Int = 10
    ) async -> Array<PSVideo> {
        var components: URLComponents = .init(string: PSURL.popularVideos)!
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
        guard let url = components.url else { return [] }
        return await fetchVideos(url: url)
    }

    /// Get a list of ``PSVideo`` based on a search query
    /// - Parameters:
    ///   - query: The search query.
    ///   - orientation: Desired video orientation.
    ///   - size: Minimum video size.
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: An array of ``PSVideo``
    public func searchVideos(
        _ query: String,
        orientation: PSOrientation? = nil,
        size: PSSize? = nil,
        page: Int = 1,
        results: Int = 10
    ) async -> Array<PSVideo> {
        var components: URLComponents = .init(string: PSURL.searchVideos)!
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
        guard let url = components.url else { return [] }
        return await fetchVideos(url: url)
    }

    /// Get a list of ``PSVideo`` based on a gived category ID
    /// - Parameters:
    ///   - categoryID: The category ID
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: An array of ``PSVideo``
    public func getVideos(
        for categoryID: String,
        page: Int = 1,
        count results: Int = 10
    ) async -> Array<PSVideo> {
        var components: URLComponents = .init(string: PSURL.collections + "/\(categoryID)")!
        let param: Array<URLQueryItem> = [.init(name: "type", value: "videos"),
                                          .init(name: "page", value: "\(page)"),
                                          .init(name: "per_page", value: "\(results)")]

        components.queryItems = param
        guard let url = components.url else { return [] }
        return await fetchVideos(url: url)
    }

    // MARK: - Private Methods

    private var cancelable: AnyCancellable?

    private static let sessionProcessingQueue = DispatchQueue(label: "SessionProcessingQueue")

    /// Fetch ``PSPhoto`` from [`URL`](https://developer.apple.com/documentation/foundation/url)
    /// - Parameter url: The URL to fetch from.
    /// - Returns: An array of ``PSPhoto``
    private func fetchPhotos(url: URL) async -> Array<PSPhoto> {
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
                    case .failure(_):
                        continuation.resume(returning: [])
                    }
                }, receiveValue: { wrapper in
                    continuation.resume(returning: wrapper.photos ?? wrapper.media ?? [])
                })
        }
    }

    /// Fetch ``PSVideo`` from [`URL`](https://developer.apple.com/documentation/foundation/url)
    /// - Parameter url: The URL to fetch from.
    /// - Returns: An array of ``PSVideo``
    private func fetchVideos(url: URL) async -> Array<PSVideo> {
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
                    case .failure(_):
                        continuation.resume(returning: [])
                    }
                }, receiveValue: { wrapper in
                    continuation.resume(returning: wrapper.videos ?? wrapper.media ?? [])
                })
        }
    }
}
