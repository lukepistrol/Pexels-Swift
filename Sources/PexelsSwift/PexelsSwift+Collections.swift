//
//  PexelsSwift+Collections.swift
//  
//
//  Created by Lukas Pistrol on 16.05.22.
//

import Foundation

public extension PexelsSwift {

    // swiftlint:disable:next type_name
    private typealias P = QueryParameter

    // MARK: Get Collections

    /// Get a list of ``PSCollection``
    /// - Parameters:
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - count: The number of results a page should contain. Defaults to `10`
    /// - Returns: A result type of ``CollectionResult``
    func getCollections(
        page: Int = 1,
        count: Int = 10
    ) async -> CollectionResult {
        guard var components: URLComponents = .init(string: API.featuredCollections)
        else {
            return .failure(.badURL(API.featuredCollections))
        }
        let param: [URLQueryItem] = [.init(name: P.page, value: page.string),
                                          .init(name: P.perPage, value: count.string)]

        components.queryItems = param
        guard let url = components.url else {
            return .failure(.badURL(components.debugDescription))
        }
        guard !apiKey.isEmpty else { return .failure(.noAPIKey) }

        let result: PSResult<CollectionResults> = await fetch(url: url)
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
            return .success((wrapper.collections, metaData, response))
        }
    }

    /// Get a list of ``PSCollection``
    /// - Parameters:
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - count: The number of results a page should contain. Defaults to `10`
    ///   - completion: A result type of ``CollectionResult``
    func getCollections(
        page: Int = 1,
        count: Int = 10,
        completion: @escaping (CollectionResult) -> Void
    ) {
        Task {
            completion(await getCollections(page: page, count: count))
        }
    }

}
