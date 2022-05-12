import XCTest
@testable import Pexels_Swift

final class Pexels_SwiftTests: XCTestCase {


    func testFeed() async throws {
        let pexels = PexelsSwift.shared
        pexels.setAPIKey(apiKey)

        let photos = await pexels.getCuratedPhotos()

        XCTAssertEqual(10, photos.count)
    }

    func testCategories() async throws {
        let pexels = PexelsSwift.shared
        pexels.setAPIKey(apiKey)

        let categories = await pexels.getCategories()

        XCTAssertEqual(10, categories.count)
    }
}
