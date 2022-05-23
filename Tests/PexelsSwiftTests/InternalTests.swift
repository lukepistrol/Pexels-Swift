//
//  InternalTests.swift
//  
//
//  Created by Lukas Pistrol on 20.05.22.
//

import XCTest
@testable import PexelsSwift

class InternalTests: XCTestCase {

    func testPrettyJSON() throws {
        let testData = """
{
  "name" : "Test"
}
"""
        guard let data = testData.data(using: .utf8),
              let result = data.prettyJSON() else {
            XCTFail("Failed to encode/decode string")
            return
        }

        XCTAssertEqual(testData, result)
    }

    func testPrettyJSONFail() throws {
        let testData = """
{
  name : "Test"
}
"""
        guard let data = testData.data(using: .utf8) else {
            XCTFail("Failed to encode string")
            return
        }
        let result = data.prettyJSON()
        XCTAssertNil(result)
    }

    func testErrorNoAPIKey() throws {
        let msg = PSError.noAPIKey.description
        XCTAssertEqual(
            "No API key was set. Call `setup(apiKey:logLevel:)` before making a request",
            msg
        )
    }

    func testErrorBadURL() throws {
        let msg = PSError.badURL.description
        XCTAssertEqual(
            "Not a valid URL",
            msg
        )
    }

    func testErrorGeneric() throws {
        let msg = PSError.generic("Test").description
        XCTAssertEqual(
            "Generic Error: Test",
            msg
        )
    }

    func testErrorHTTPResponse() throws {
        let msg = PSError.httpResponse(404).description
        XCTAssertEqual(
            "HTTP Error. Status code: 404",
            msg
        )
    }

    func testErrorNoContent() throws {
        let msg = PSError.noContent.description
        XCTAssertEqual(
            "No content was found",
            msg
        )
    }

    func testErrorNoResponse() throws {
        let msg = PSError.noResponse.description
        XCTAssertEqual(
            "No response from server",
            msg
        )
    }

    func testRateLimitResetFailure() throws {
        let response = HTTPURLResponse(
            url: .init(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        XCTAssertNil(response.pexelsReset)
    }

    func testRateLimitFailure() throws {
        let response = HTTPURLResponse(
            url: .init(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        XCTAssertNil(response.pexelsLimit)
    }

    func testRateLimitRemainingFailure() throws {
        let response = HTTPURLResponse(
            url: .init(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        XCTAssertNil(response.pexelsRemaining)
    }
}
