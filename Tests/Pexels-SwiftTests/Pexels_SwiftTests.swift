import XCTest
@testable import Pexels_Swift

final class Pexels_SwiftTests: XCTestCase {

    var pexels: PexelsSwift?

    override func setUp() async throws {
        self.pexels = PexelsSwift()
    }

    override func tearDown() async throws {
        self.pexels = nil
    }

    func testFeed() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let photos = await pexels.getCuratedPhotos()

        XCTAssertEqual(10, photos.count)
    }

    func testCategories() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        pexels.setAPIKey(apiKey)
        let categories = await pexels.getCategories()

        XCTAssertEqual(10, categories.count)
    }

    func testFeedNoAPIKey() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        let photos = await pexels.getCuratedPhotos()

        XCTAssertEqual(0, photos.count)
    }

    func testCategoriesNoAPIKey() async throws {
        guard let pexels = pexels else { XCTFail("self.pexels == nil"); return }
        let categories = await pexels.getCategories()

        XCTAssertEqual(0, categories.count)
    }
}
