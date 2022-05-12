import Foundation
import Combine

public class PexelsSwift {
    private init() {}

    public static let shared: PexelsSwift = .init()

    private var cancelable: AnyCancellable?

    private static let sessionProcessingQueue = DispatchQueue(label: "SessionProcessingQueue")

    private let apiHeader: String = "Authorization"

    private var apiKey: String = ""

    public func setAPIKey(_ key: String) {
        self.apiKey = key
    }

    public func fetchCollectionCategories(page: Int = 1, completion: @escaping (Array<CollectionCategory>) -> ()) {
        var req = URLRequest(url: URL(string: "https://api.pexels.com/v1/collections/featured?page=\(page)")!)
        req.setValue(apiKey, forHTTPHeaderField: apiHeader)

        cancelable = URLSession.shared.dataTaskPublisher(for: req)
            .subscribe(on: Self.sessionProcessingQueue)
            .map({ return $0.data })
            .decode(type: CollectionCategoriesWrapper.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { subCompletion in
                switch subCompletion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { (wrapper) in
                completion(wrapper.collections)
            })
    }

    public func fetch(_ type: StreamType = .curated,
                      searchText query: String? = nil,
                      page: Int = 1) async -> Array<PSPhoto> {
        var url1: URLComponents = url(for: type, collectionID: query ?? "")
        var param: Array<URLQueryItem> = [.init(name: "page", value: "\(page)"),
                                          .init(name: "per_page", value: "80")]

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

        url1.queryItems = param
        guard let url2 = url1.url else { return [] }
        return await fetch(url2)
    }

    private func fetch(_ url: URL) async -> Array<PSPhoto> {
        var req = URLRequest(url: url)
        req.setValue(apiKey, forHTTPHeaderField: apiHeader)

        return await withCheckedContinuation { continuation in
            cancelable = URLSession.shared.dataTaskPublisher(for: req)
                .subscribe(on: Self.sessionProcessingQueue)
                .map({ return $0.data })
                .decode(type: ResultsWrapper.self, decoder: JSONDecoder())
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

    struct ResultsWrapper: Codable {
        var photos: Array<PSPhoto>? // When searching, or featured
        var media: Array<PSPhoto>? // When fetching from collections
        var page: Int
        var per_page: Int
        var total_results: Int
        var prev_page: String?
        var next_page: String?
    }

    struct CollectionCategoriesWrapper: Codable {
        var collections: Array<CollectionCategory>
        var page: Int
        var per_page: Int
        var total_results: Int
        var prev_page: String?
        var next_page: String?
    }

    public enum StreamType: String {
        case curated, search, collections
    }
}
