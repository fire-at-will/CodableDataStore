import XCTest
@testable import CodableDataStore

final class CodableDataStoreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CodableDataStore().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
