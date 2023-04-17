//
//  VANetworkImageNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 15.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

//https://img.freepik.com/free-vector/hand-painted-watercolor-pastel-sky-background_23-2148902771.jpg?w=360

import XCTest
@testable import VATextureKit_Example
import VATextureKit

class VANetworkImageNodeTests: XCTestCase {

    func test_parsing_url() {
        let imageURLString = "https://img.freepik.com/free-vector/hand-painted-watercolor-pastel-sky-background_23-2148902771.jpg?w=360"
        let expectedURL = URL(string: imageURLString)!

        XCTAssertEqual(.url(expectedURL), VANetworkImageNode.parseImage(string: imageURLString))
    }

    func test_parsing_image() {
        let imageFileString = Bundle(for: VANetworkImageNodeTests.self).path(forResource: "test_image", ofType: "jpg")!
        let expectedImage = UIImage(contentsOfFile: imageFileString)!

        XCTAssertEqual(expectedImage.pngData(), VANetworkImageNode.parseImage(string: imageFileString).image?.pngData())
    }

    func test_parsing_file() {
        let imageFileString = "file://" + Bundle(for: VANetworkImageNodeTests.self).path(forResource: "test_image", ofType: "jpg")!
        let expectedImage = UIImage(contentsOfFile: URL(string: imageFileString)!.path())!

        XCTAssertEqual(expectedImage.pngData(), VANetworkImageNode.parseImage(string: imageFileString).image?.pngData())
    }
}
