//
//  PexelsSwiftTests.swift
//
//
//  Created by Lukas Pistrol on 12.05.22.
//

import XCTest
@testable import PexelsSwift

final class Pexels_SwiftTests: XCTestCase {

//    let apiKey = ProcessInfo.processInfo.environment["PEXELS_API_KEY"] ?? ""

    let timeOut: TimeInterval = 20
    let logLevel: PSLogLevel = .off

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
        case .success(let photo):
            XCTAssertEqual(photo.id, 2014422)
        }
    }

    func testCuratedPhotos() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getCuratedPhotos(count: 1)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (photos, _)):
            XCTAssertFalse(photos.isEmpty)
        }
    }

    func testSearchPhotos() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.searchPhotos("Ocean", count: 1)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (photos, _)):
            XCTAssertFalse(photos.isEmpty)
        }
    }

    func testGetPhotosFromCollection() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getPhotos(for: "hoxyyjd", count: 1)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (photos, _)):
            XCTAssertFalse(photos.isEmpty)
        }
    }

    func testCollections() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getCollections(count: 1)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (categories, _)):
            XCTAssertFalse(categories.isEmpty)
        }

    }

    func testNoAPIKey() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: "", logLevel: logLevel)
        let result = await pexels.getCuratedPhotos(count: 1)
        
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .noAPIKey)
        case .success(_):
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
        case .success(let video):
            XCTAssertEqual(video.id, 6466763)
        }
    }

    func testGetPopularVideos() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getPopularVideos(count: 1)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (videos, _)):
            XCTAssertFalse(videos.isEmpty)
        }

    }

    func testSearchVideos() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.searchVideos("Ocean", count: 1)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (videos, _)):
            XCTAssertFalse(videos.isEmpty)
        }
    }

    func testGetVideosFromCollection() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        let result = await pexels.getVideos(for: "8xntbhr", count: 1)

        switch result {
        case .failure(let error):
            XCTFail(error.description)
        case .success(let (videos, _)):
            XCTAssertFalse(videos.isEmpty)
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
            case .success(let photo):
                XCTAssertEqual(photo.id, 2014422)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testCuratedPhotosClosure() throws {
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getCuratedPhotos(count: 1) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (photos, _)):
                XCTAssertFalse(photos.isEmpty)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testSearchPhotosClosure() throws {
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.searchPhotos("Ocean", count: 1) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (photos, _)):
                XCTAssertFalse(photos.isEmpty)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testGetPhotosFromCollectionClosure() throws {
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getPhotos(for: "hoxyyjd", count: 1) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (photos, _)):
                XCTAssertFalse(photos.isEmpty)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testCollectionsClosure() throws {
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getCollections(count: 1) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (categories, _)):
                XCTAssertFalse(categories.isEmpty)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testNoAPIKeyClosure() throws {
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: "", logLevel: logLevel)
        pexels.getCuratedPhotos(count: 1) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noAPIKey)
            case .success(_):
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
            case .success(let video):
                XCTAssertEqual(video.id, 6466763)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testGetPopularVideosClosure() throws {
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getPopularVideos(count: 1) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (videos, _)):
                XCTAssertFalse(videos.isEmpty)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testSearchVideosClosure() throws {
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.searchVideos("Ocean", count: 1) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (videos, _)):
                XCTAssertFalse(videos.isEmpty)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }

    func testGetVideosFromCollectionClosure() throws {
        let expectation = expectation(description: "closure")
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setup(apiKey: apiKey, logLevel: logLevel)
        pexels.getVideos(for: "8xntbhr", count: 1) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.description)
            case .success(let (videos, _)):
                XCTAssertFalse(videos.isEmpty)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeOut)
    }
}
