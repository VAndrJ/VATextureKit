//
//  ASCollectionNodeTests.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import XCTest
@testable import VATextureKit_Example
import VATextureKitRx
import RxSwift
import RxCocoa

class ASCollectionNodeTests: XCTestCase, MainActorIsolated {

    func test_direction() {
        let node = VAListNode(
            data: .init(listDataObs: Observable<[String]>.never(), cellGetter: { _ in ASCellNode() }),
            layoutData: .init(layout: .default(parameters: .init(scrollDirection: .horizontal)))
        )

        XCTAssertTrue(node.isHorizontal)
    }
}
