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
        let photo = await pexels.getPhoto(by: 2014422)
        
        XCTAssertNotNil(photo)
    }

    func testCuratedPhotos() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let photos = await pexels.getCuratedPhotos()

        XCTAssertFalse(photos.isEmpty)
    }

    func testSearchPhotos() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let photos = await pexels.searchPhotos("Ocean")

        XCTAssertFalse(photos.isEmpty)
    }

    func testGetPhotosFromCollection() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let photos = await pexels.getPhotos(for: "hoxyyjd")

        XCTAssertFalse(photos.isEmpty)
    }

    func testCategories() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let categories = await pexels.getCategories()

        XCTAssertFalse(categories.isEmpty)
    }

    func testNoAPIKey() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        let photos = await pexels.getCuratedPhotos()

        XCTAssertTrue(photos.isEmpty)
    }

    func testGetVideoByID() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let video = await pexels.getVideo(by: 6466763)

        XCTAssertNotNil(video)
    }

    func testGetPopularVideos() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)

        let videos = await pexels.getPopularVideos()
        XCTAssertFalse(videos.isEmpty)

    }

    func testSearchVideos() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let videos = await pexels.searchVideos("Ocean")

        XCTAssertFalse(videos.isEmpty)
    }

    func testGetVideosFromCollection() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let videos = await pexels.getVideos(for: "8xntbhr")

        XCTAssertFalse(videos.isEmpty)
    }
}
