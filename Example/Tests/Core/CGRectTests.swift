//
//  CGRectTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class CGRectTests: XCTestCase {
    
    func test_position() {
        let value = 10.0
        var rect = CGRect(x: value, y: value, width: value, height: value)
        
        XCTAssertEqual(CGPoint(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2), rect.position)
        
        rect.position = .zero
        
        XCTAssertEqual(CGPoint(x: -rect.width / 2, y: -rect.height / 2), rect.origin)
    }
    
    func test_init() {
        let value = 10.0
        let expected = CGRect(x: 0, y: 0, width: value, height: value * 2)
        
        XCTAssertEqual(expected, CGRect(width: value, height: value * 2))
    }
    
    func test_init_size() {
        let value = 10.0
        let expected = CGRect(x: 0, y: 0, width: value, height: value)
        
        XCTAssertEqual(expected, CGRect(size: .init(width: value, height: value)))
    }
    
    func test_area() {
        let rect1 = CGRect(size: .init(same: 1))
        let rect2 = CGRect(size: .init(width: 2, height: 3))
        
        XCTAssertEqual(1, rect1.area)
        XCTAssertEqual(6, rect2.area)
    }
    
    func test_ratio() {
        let rect1 = CGRect(size: .init(same: 1))
        let rect2 = CGRect(size: .init(width: 2, height: 3))
        let rect3 = CGRect(size: .init(width: 2, height: 1))
        
        XCTAssertEqual(1, rect1.ratio)
        XCTAssertEqual(2 / 3, rect2.ratio)
        XCTAssertEqual(2, rect3.ratio)
    }
}
