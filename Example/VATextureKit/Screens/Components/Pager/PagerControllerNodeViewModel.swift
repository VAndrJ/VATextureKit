//
//  PagerControllerNodeViewModel.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 24.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

final class PagerControllerNodeViewModel {
    @Obs.Relay(value: (0...2).map { PagerCardCellNodeViewModel(title: "Title \($0)", description: "Description \($0)") })
    var pagerItemsObs: Observable<[CellViewModel]>

    func generateRandomPagerItems() {
        let randomInt = Int.random(in: 0...10_000_000)
        let items = (randomInt...(randomInt + Int.random(in: 0...4))).map { PagerCardCellNodeViewModel(title: "Title \($0)", description: "Description \($0)") }
        _pagerItemsObs.rx.accept(items)
    }
}
