//
//  ArrayTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class ArrayTests: XCTestCase {

    func test_sum_withElement() {
        let value = 2
        let array = [0, 1, 10]
        let expectedArray = array.map { $0 + value }

        XCTAssertEqual(expectedArray, array + value)
    }

    func test_builder_emptyValue() {
        let sut = pipeFunc(array: .init {
        })
        XCTAssertEqual([], sut)
    }

    func test_builder_optionalNilValue() {
        let opt: Int? = nil
        let sut = pipeFunc(array: .init {
            opt
        })
        XCTAssertEqual([], sut)
    }

    func test_builder_singleValue() {
        let sut = pipeFunc(array: .init {
            1
        })
        XCTAssertEqual([1], sut)
    }

    func test_builder_optionalValue() {
        let opt: Int? = 2
        let sut = pipeFunc(array: .init {
            1
            if let opt {
                opt
            }
        })
        XCTAssertEqual([1, 2], sut)
    }

    func test_builder_optionalValue1() {
        let opt: Int? = 2
        let sut = pipeFunc(array: .init {
            1
            opt
        })
        XCTAssertEqual([1, 2], sut)
    }

    func test_builder_optionalNilValue1() {
        let opt: Int? = nil
        let sut = pipeFunc(array: .init {
            1
            opt
        })
        XCTAssertEqual([1], sut)
    }

    func test_builder_optionalNilValue2() {
        let opt: [Int?] = []
        let sut = pipeFunc(array: .init {
            opt
            1
        })
        XCTAssertEqual([1], sut)
    }

    func test_builder_optionalValue2() {
        let opt: [Int?] = [2]
        let sut = pipeFunc(array: .init {
            opt
            1
        })
        XCTAssertEqual([2, 1], sut)
    }

    func test_builder_array() {
        let sut = pipeFunc(array: .init {
            [1, 2]
        })
        XCTAssertEqual([1, 2], sut)
    }

    func test_builder_arrayPlusValue() {
        let sut = pipeFunc(array: .init {
            [1, 2]
            3
        })
        XCTAssertEqual([1, 2, 3], sut)
    }

    func test_builder_switch() {
        let val = 0
        let sut = pipeFunc(array: .init {
            switch val {
            case 0:
                [1]
            default:
                [2]
            }
        })
        XCTAssertEqual([1], sut)
    }

    func test_builder_for() {
        let sut = pipeFunc(array: .init {
            for i in 1...3 {
                i
            }
        })
        XCTAssertEqual([1, 2, 3], sut)
    }

    func test_builder_if() {
        let val = 0
        let sut = pipeFunc(array: .init {
            if val == 0 {
                1
            } else {
                [2]
            }
        })
        XCTAssertEqual([1], sut)
    }

    func test_builder_ifElse() {
        let val = 1
        let sut = pipeFunc(array: .init {
            if val == 0 {
                1
            } else {
                [2]
            }
        })
        XCTAssertEqual([2], sut)
    }

    func test_builder_switchDefault() {
        let val = 1
        let sut = pipeFunc(array: .init {
            switch val {
            case 0:
                [1]
            default:
                [2]
            }
        })
        XCTAssertEqual([2], sut)
    }

    private func pipeFunc(array: [Int]) -> [Int] {
        array
    }
}
