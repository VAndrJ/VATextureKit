//
//  ScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 11.03.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx
import RxSwift
import RxCocoa

class ScreenNode: VASafeAreaDisplayNode, @unchecked Sendable {
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        bind()
    }

    @MainActor
    func bind() {}

    @MainActor
    func configure() {}
}
