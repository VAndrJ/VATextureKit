//
//  MoviesTests
//
//  Created by VAndrJ on 16.04.2023.
//

import XCTest
@testable import MoviesExample

final class CollectionTests: XCTestCase {

    func test_isNotEmpty() {
        let emptyArr: [Int] = []
        let notEmptyArr = [1]

        XCTAssertFalse(emptyArr.isNotEmpty)
        XCTAssertTrue(notEmptyArr.isNotEmpty)
    }

    func test_Int_isEmpty_optional() {
        let nilArr: [Int]? = nil
        let emptyArr: [Int]? = []
        let notEmptyArr: [Int]? = [1]

        XCTAssertTrue(nilArr.isEmpty)
        XCTAssertTrue(emptyArr.isEmpty)
        XCTAssertFalse(notEmptyArr.isEmpty)
    }

    func test_Int_isNotEmpty_optional() {
        let nilArr: [Int]? = nil
        let emptyArr: [Int]? = []
        let notEmptyArr: [Int]? = [1]

        XCTAssertFalse(nilArr.isNotEmpty)
        XCTAssertFalse(emptyArr.isNotEmpty)
        XCTAssertTrue(notEmptyArr.isNotEmpty)
    }

    func test_String_isEmpty_optional() {
        let nilArr: String? = nil
        let emptyArr: String? = ""
        let notEmptyArr: String? = "[1]"

        XCTAssertTrue(nilArr.isEmpty)
        XCTAssertTrue(emptyArr.isEmpty)
        XCTAssertFalse(notEmptyArr.isEmpty)
    }

    func test_String_isNotEmpty_optional() {
        let nilArr: String? = nil
        let emptyArr: String? = ""
        let notEmptyArr: String? = "[1]"

        XCTAssertFalse(nilArr.isNotEmpty)
        XCTAssertFalse(emptyArr.isNotEmpty)
        XCTAssertTrue(notEmptyArr.isNotEmpty)
    }
}
