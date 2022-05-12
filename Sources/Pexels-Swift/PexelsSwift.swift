import Foundation
import Combine

public class PexelsSwift {
    private init() {}

    /// The singleton instance of ``PexelsSwift``
    public static let shared: PexelsSwift = .init()

    private var cancelable: AnyCancellable?

    private static let sessionProcessingQueue = DispatchQueue(label: "SessionProcessingQueue")

    private let apiHeader: String = "Authorization"

    private var apiKey: String = ""

    // MARK: - Public Methods

    /// Set the API key to make API Queries.
    ///
    /// An API Key can be obtained from [here](https://www.pexels.com/api/)
    /// - Parameter key: The API Key
    public func setAPIKey(_ key: String) {
        self.apiKey = key
    }

    public func getCategories(
        page: Int = 1,
        count results: Int = 10
    ) async -> Array<CollectionCategory> {
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
                        print(error)
                    }
                }, receiveValue: { (wrapper) in
                    continuation.resume(returning: wrapper.collections)
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
        await fetchPhotos(.curated, searchText: nil, page: page, results: results)
    }

    /// Get a list of ``PSPhoto`` based on a search query
    /// - Parameters:
    ///   - search: Your search text
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: An array of ``PSPhoto``
    public func getPhotos(
        search: String,
        page: Int = 1,
        count results: Int = 10
    ) async -> Array<PSPhoto> {
        await fetchPhotos(.search, searchText: search, page: page, results: 10)
    }

    // MARK: - Private Methods

    private func fetchPhotos(
        _ type: StreamType = .curated,
        searchText query: String? = nil,
        page: Int = 1,
        results: Int = 10
    ) async -> Array<PSPhoto> {
        var components: URLComponents = url(for: type, collectionID: query ?? "")
        var param: Array<URLQueryItem> = [.init(name: "page", value: "\(page)"),
                                          .init(name: "per_page", value: "\(results)")]

        switch type {
        case .curated:
            break
        case .search:
            guard let query1 = query else { return [] }
            param.append(.init(name: "query", value: query1))
            break
        case .collections:
            param.append(.init(name: "type", value: "photos"))
            break
        }

        components.queryItems = param
        guard let url = components.url else { return [] }
        var req = URLRequest(url: url)
        req.setValue(apiKey, forHTTPHeaderField: apiHeader)

        return await withCheckedContinuation { continuation in
            cancelable = URLSession.shared.dataTaskPublisher(for: req)
                .subscribe(on: Self.sessionProcessingQueue)
                .map({ return $0.data })
                .decode(type: ContentResults.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { subCompletion in
                    switch subCompletion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                }, receiveValue: { (wrapper) in
                    continuation.resume(returning: wrapper.photos ?? wrapper.media ?? [])
                })
        }
    }

    private func url(for type: StreamType, collectionID: String) -> URLComponents {
        switch type {
        case .curated: return URLComponents(string: PSURL.curated)!
        case .search: return URLComponents(string: PSURL.search)!
        case .collections: return URLComponents(string: PSURL.collections + "/" + collectionID)!
        }
    }

    private func url(for type: StreamType) -> String {
        if type == .curated { return PSURL.curated }
        if type == .search { return PSURL.search }
        return ""
    }
}
