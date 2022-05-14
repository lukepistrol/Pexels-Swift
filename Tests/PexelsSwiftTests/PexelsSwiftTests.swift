import XCTest
@testable import PexelsSwift

final class Pexels_SwiftTests: XCTestCase {

    var pexels: PexelsSwift?

    override func setUp() async throws {
        self.pexels = PexelsSwift()
    }

    override func tearDown() async throws {
        self.pexels = nil
    }

    func testGetPhotoByID() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let result = await pexels.getPhoto(by: 2014422)

        switch result {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .success(let photo):
            XCTAssertEqual(photo.id, 2014422)
        }
    }

    func testCuratedPhotos() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let result = await pexels.getCuratedPhotos()

        switch result {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .success(let photos):
            XCTAssertFalse(photos.isEmpty)
        }
    }

    func testSearchPhotos() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let result = await pexels.searchPhotos("Ocean")

        switch result {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .success(let photos):
            XCTAssertFalse(photos.isEmpty)
        }
    }

    func testGetPhotosFromCollection() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let result = await pexels.getPhotos(for: "hoxyyjd")

        switch result {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .success(let photos):
            XCTAssertFalse(photos.isEmpty)
        }
    }

    func testCategories() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let result = await pexels.getCollections()

        switch result {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .success(let categories):
            XCTAssertFalse(categories.isEmpty)
        }

    }

    func testNoAPIKey() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        let result = await pexels.getCuratedPhotos()

        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .noAPIKey)
        case .success(_):
            XCTFail("Should not return a value")
        }
    }

    func testGetVideoByID() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let result = await pexels.getVideo(by: 6466763)

        switch result {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .success(let video):
            XCTAssertEqual(video.id, 6466763)
        }
    }

    func testGetPopularVideos() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let result = await pexels.getPopularVideos()

        switch result {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .success(let videos):
            XCTAssertFalse(videos.isEmpty)
        }

    }

    func testSearchVideos() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let result = await pexels.searchVideos("Ocean")

        switch result {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .success(let videos):
            XCTAssertFalse(videos.isEmpty)
        }
    }

    func testGetVideosFromCollection() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let result = await pexels.getVideos(for: "8xntbhr")

        switch result {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .success(let videos):
            XCTAssertFalse(videos.isEmpty)
        }
    }
}
