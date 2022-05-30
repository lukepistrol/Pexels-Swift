//
//  PexelsSwiftTests.swift
//
//
//  Created by Lukas Pistrol on 12.05.22.
//

import XCTest
@testable import PexelsSwift

// swiftlint:disable:next type_body_length
final class PexelsSwiftTests: XCTestCase {

    let apiKey = "API_KEY_PLACEHOLDER"

    let timeOut: TimeInterval = 20
    let logLevel: PSLogLevel = .debug
    let results: Int = 1

    var pexels: PexelsSwift?

    override func setUp() async throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        self.pexels = PexelsSwift(urlSession: urlSession)
    }

    override func tearDown() async throws {
        self.pexels = nil
    }

    func setRequestHandler(with data: Data?, statusCode: Int = 200) {
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw PSError.badURL
            }

            let response = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: [
                    PexelsSwift.RateLimitType.limit.rawValue : "100000",
                    PexelsSwift.RateLimitType.remaining.rawValue: "99999",
                    PexelsSwift.RateLimitType.reset.rawValue: "\(Date.distantFuture.timeIntervalSince1970)"
                ]
            )!
            return (response, data)
        }
    }

    // MARK: - Async/Await

    func test404() async throws {
        setRequestHandler(with: nil, statusCode: 404)

        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getCuratedPhotos()

        switch result {
        case .failure(let error):
            XCTAssertEqual(PSError.httpResponse(404), error)
        case .success(_):
            XCTFail("Should not return a value")
        }
    }

    func testNoContent() async throws {
        let data = noContent.data(using: .utf8)
        setRequestHandler(with: data)

        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getPhotos(for: "hoxyyjd", count: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(PSError.noContent, error)
        case .success(_):
            XCTFail("Should not return a value")
        }
    }

    func testGetPhotoByID() async throws {
        let data = singlePhoto.data(using: .utf8)
        setRequestHandler(with: data)

        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getPhoto(by: 2014422)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, response)):
            XCTAssertEqual(data.id, 2014422)
            XCTAssertEqual(response.statusCode, 200)
        }
    }

    func testCuratedPhotos() async throws {
        let data = photosCollection.data(using: .utf8)
        setRequestHandler(with: data)

        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getCuratedPhotos(count: 1)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, _, response)):
            XCTAssertEqual(data.count, 1)
            XCTAssertEqual(response.statusCode, 200)
        }
    }

    func testSearchPhotos() async throws {
        let data = photosCollection.data(using: .utf8)
        setRequestHandler(with: data)

        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.searchPhotos("Ocean",
                                               orientation: .landscape,
                                               size: .medium,
                                               color: .blue,
                                               locale: .en_US,
                                               count: 1)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, _, response)):
            XCTAssertEqual(data.count, 1)
            XCTAssertEqual(response.statusCode, 200)
        }
    }

    func testGetPhotosFromCollection() async throws {
        let data = photosCollection.data(using: .utf8)
        setRequestHandler(with: data)

        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getPhotos(for: "hoxyyjd", count: 1)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, _, response)):
            XCTAssertEqual(data.count, 1)
            XCTAssertEqual(response.statusCode, 200)
        }
    }

    func testCollections() async throws {
        let data = collection.data(using: .utf8)
        setRequestHandler(with: data)

        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getCollections(count: 1)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, _, response)):
            XCTAssertEqual(data.count, 1)
            XCTAssertEqual(response.statusCode, 200)
        }

    }

    func testNoAPIKey() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: "", logLevel: logLevel)
        let result = await pexels.getCuratedPhotos(count: results)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .noAPIKey)
        case .success:
            XCTFail("Should not return a value")
        }
    }

    func testGetVideoByID() async throws {
        let data = singleVideo.data(using: .utf8)
        setRequestHandler(with: data)

        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getVideo(by: 6466763)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, response)):
            XCTAssertEqual(data.id, 6466763)
            XCTAssertEqual(response.statusCode, 200)
        }
    }

    func testGetPopularVideos() async throws {
        let data = videosCollection.data(using: .utf8)
        setRequestHandler(with: data)

        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getPopularVideos(minimumWidth: 100,
                                                   minimumHeight: 100,
                                                   minimumDuration: 1,
                                                   maximumDuration: 10000,
                                                   count: 1)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, _, response)):
            XCTAssertEqual(data.count, 1)
            XCTAssertEqual(response.statusCode, 200)
        }

    }

    func testSearchVideos() async throws {
        let data = videosCollection.data(using: .utf8)
        setRequestHandler(with: data)

        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.searchVideos("Ocean",
                                               orientation: .landscape,
                                               size: .medium,
                                               locale: .en_US,
                                               count: 1)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, _, response)):
            XCTAssertEqual(data.count, 1)
            XCTAssertEqual(response.statusCode, 200)
        }
    }

    func testGetVideosFromCollection() async throws {
        let data = videosCollection.data(using: .utf8)
        setRequestHandler(with: data)

        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getVideos(for: "8xntbhr", count: 1)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, _, response)):
            XCTAssertEqual(data.count, 1)
            XCTAssertEqual(response.statusCode, 200)
        }
    }

    // MARK: Completion Handlers

    func testGetPhotoByIDClosure() throws {
        let data = singlePhoto.data(using: .utf8)
        setRequestHandler(with: data)

        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getPhoto(by: 2014422) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, response)):
                XCTAssertEqual(data.id, 2014422)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testCuratedPhotosClosure() throws {
        let data = photosCollection.data(using: .utf8)
        setRequestHandler(with: data)

        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getCuratedPhotos(count: 1) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, _, response)):
                XCTAssertEqual(data.count, 1)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testSearchPhotosClosure() throws {
        let data = photosCollection.data(using: .utf8)
        setRequestHandler(with: data)

        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.searchPhotos("Ocean", count: 1) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, _, response)):
                XCTAssertEqual(data.count, 1)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testGetPhotosFromCollectionClosure() throws {
        let data = photosCollection.data(using: .utf8)
        setRequestHandler(with: data)

        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getPhotos(for: "hoxyyjd", count: 1) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, _, response)):
                XCTAssertEqual(data.count, 1)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testCollectionsClosure() throws {
        let data = collection.data(using: .utf8)
        setRequestHandler(with: data)

        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getCollections(count: 1) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, _, response)):
                XCTAssertEqual(data.count, 1)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testNoAPIKeyClosure() throws {
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: "", logLevel: logLevel)
        pexels.getCuratedPhotos(count: results) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noAPIKey)
            case .success:
                XCTFail("Should not return a value")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testGetVideoByIDClosure() throws {
        let data = singleVideo.data(using: .utf8)
        setRequestHandler(with: data)

        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getVideo(by: 6466763) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, response)):
                XCTAssertEqual(data.id, 6466763)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testGetPopularVideosClosure() throws {
        let data = videosCollection.data(using: .utf8)
        setRequestHandler(with: data)

        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getPopularVideos(count: 1) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, _, response)):
                XCTAssertEqual(data.count, 1)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testSearchVideosClosure() throws {
        let data = videosCollection.data(using: .utf8)
        setRequestHandler(with: data)

        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.searchVideos("Ocean", count: 1) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, _, response)):
                XCTAssertEqual(data.count, 1)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testGetVideosFromCollectionClosure() throws {
        let data = videosCollection.data(using: .utf8)
        setRequestHandler(with: data)

        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getVideos(for: "8xntbhr", count: 1) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, _, response)):
                XCTAssertEqual(data.count, 1)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }
}
