import Foundation
import XCTest

class OCResult2SwiftTests : XCTestCase {
    func test_to_swift_of_success() {
        let result1 = OCResult.success("hello")
        let result2 = result1.toSwift()
        switch result2 {
        case .success(let value):
            XCTAssertEqual(value as? String, "hello")
        case .failure(_):
            XCTFail()
        }
    }

    func test_to_swift_of_failure() {
        let expectedError = NSError(domain: "example.com", code: 1, userInfo: nil)
        let result1 = OCResult.failure(expectedError)
        let result2 = result1.toSwift()
        switch result2 {
        case .success(_):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error as NSError, expectedError)
        }
    }

    func test_make_from_swift_success() {
        let result1 = Result<NSString, NSError>.success("hello")
        let result2 = OCResult.make(fromSwiftResult: result1)
        XCTAssertEqual(result2.kind, OCResultKind.success)
        XCTAssertEqual(result2.value as? String, "hello")
    }

    func test_make_from_swift_failure() {
        let expectedError = NSError(domain: "example.com", code: 1, userInfo: nil)
        let result1 = Result<NSString, NSError>.failure(expectedError)
        let result2 = OCResult.make(fromSwiftResult: result1)
        XCTAssertEqual(result2.kind, OCResultKind.failure)
        XCTAssertEqual(result2.error as NSError, expectedError)
    }
}
