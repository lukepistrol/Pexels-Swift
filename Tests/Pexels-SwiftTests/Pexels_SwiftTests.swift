import XCTest
@testable import Pexels_Swift

final class Pexels_SwiftTests: XCTestCase {


    func testExample() async throws {
        let pexels = PexelsSwift.shared
        pexels.setAPIKey(apiKey)

        let photos = await pexels.fetch()

        print(photos.count)
    }
}
