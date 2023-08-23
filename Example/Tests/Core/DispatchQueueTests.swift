//
//  DispatchQueueTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class DispatchQueueTests: XCTestCase {
    
    func test_global() {
        let expect = expectation(description: "Queue expectation")
        ensureOnGlobal {
            XCTAssertFalse(Thread.isMainThread)
            ensureOnGlobal {
                XCTAssertFalse(Thread.isMainThread)
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 10)
    }
    
    func test_global_background() {
        let expect = expectation(description: "Queue expectation")
        ensureOnBackground {
            XCTAssertFalse(Thread.isMainThread)
            ensureOnBackground {
                XCTAssertFalse(Thread.isMainThread)
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 10)
    }
    
    func test_main() {
        let expect = expectation(description: "Queue expectation")
        ensureOnBackground {
            XCTAssertFalse(Thread.isMainThread)
            ensureOnMain {
                XCTAssertTrue(Thread.isMainThread)
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 10)
    }
    
    func test_main_async() {
        let expect = expectation(description: "Queue expectation")
        ensureOnBackground {
            XCTAssertFalse(Thread.isMainThread)
            mainAsync {
                XCTAssertTrue(Thread.isMainThread)
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 10)
    }

    func test_main_asyncAfter() {
        let expect = expectation(description: "Queue expectation")
        ensureOnBackground {
            XCTAssertFalse(Thread.isMainThread)
            mainAsync(after: 0.1) {
                XCTAssertTrue(Thread.isMainThread)
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 10)
    }
}
