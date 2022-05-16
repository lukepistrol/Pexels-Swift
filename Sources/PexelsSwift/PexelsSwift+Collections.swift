//
//  PexelsSwift+Collections.swift
//  
//
//  Created by Lukas Pistrol on 16.05.22.
//

import Foundation

public extension PexelsSwift {

    // MARK: Get Collections

    /// Get a list of ``PSCollection``
    /// - Parameters:
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: A result type of ``CollectionResult``
    func getCollections(
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
    func getCollections(
        page: Int = 1,
        count results: Int = 10,
        completion: @escaping (CollectionResult) -> Void
    ) {
        Task {
            completion(await getCollections(page: page, count: results))
        }
    }

}
