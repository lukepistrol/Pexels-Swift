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

    let apiKey = ProcessInfo.processInfo.environment["PEXELS_API_KEY"] ?? ""

    let timeOut: TimeInterval = 20
    let logLevel: PSLogLevel = .debug
    let results: Int = 1

    var pexels: PexelsSwift?

    override func setUp() async throws {
        self.pexels = PexelsSwift()
    }

    override func tearDown() async throws {
        self.pexels = nil
    }

    // MARK: - Async/Await

    func testGetPhotoByID() async throws {
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
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getCuratedPhotos(count: results)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, _, response)):
            XCTAssertFalse(data.isEmpty)
            XCTAssertEqual(response.statusCode, 200)
        }
    }

    func testSearchPhotos() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.searchPhotos("Ocean",
                                               orientation: .landscape,
                                               size: .medium,
                                               color: .blue,
                                               locale: .en_US,
                                               count: results)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, _, response)):
            XCTAssertFalse(data.isEmpty)
            XCTAssertEqual(response.statusCode, 200)
        }
    }

    func testGetPhotosFromCollection() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getPhotos(for: "hoxyyjd", count: results)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, _, response)):
            XCTAssertFalse(data.isEmpty)
            XCTAssertEqual(response.statusCode, 200)
        }
    }

    func testCollections() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getCollections(count: results)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, _, response)):
            XCTAssertFalse(data.isEmpty)
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
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getPopularVideos(minimumWidth: 100,
                                                   minimumHeight: 100,
                                                   minimumDuration: 1,
                                                   maximumDuration: 10000,
                                                   count: results)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, _, response)):
            XCTAssertFalse(data.isEmpty)
            XCTAssertEqual(response.statusCode, 200)
        }

    }

    func testSearchVideos() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.searchVideos("Ocean",
                                               orientation: .landscape,
                                               size: .medium,
                                               locale: .en_US,
                                               count: results)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, _, response)):
            XCTAssertFalse(data.isEmpty)
            XCTAssertEqual(response.statusCode, 200)
        }
    }

    func testGetVideosFromCollection() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getVideos(for: "8xntbhr", count: results)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (data, _, response)):
            XCTAssertFalse(data.isEmpty)
            XCTAssertEqual(response.statusCode, 200)
        }
    }

    // MARK: Completion Handlers

    func testGetPhotoByIDClosure() throws {
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
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getCuratedPhotos(count: results) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, _, response)):
                XCTAssertFalse(data.isEmpty)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testSearchPhotosClosure() throws {
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.searchPhotos("Ocean", count: results) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, _, response)):
                XCTAssertFalse(data.isEmpty)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testGetPhotosFromCollectionClosure() throws {
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getPhotos(for: "hoxyyjd", count: results) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, _, response)):
                XCTAssertFalse(data.isEmpty)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testCollectionsClosure() throws {
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getCollections(count: results) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, _, response)):
                XCTAssertFalse(data.isEmpty)
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
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getPopularVideos(count: results) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, _, response)):
                XCTAssertFalse(data.isEmpty)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testSearchVideosClosure() throws {
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.searchVideos("Ocean", count: results) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, _, response)):
                XCTAssertFalse(data.isEmpty)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testGetVideosFromCollectionClosure() throws {
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getVideos(for: "8xntbhr", count: results) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (data, _, response)):
                XCTAssertFalse(data.isEmpty)
                XCTAssertEqual(response.statusCode, 200)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }
}
