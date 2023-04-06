//
//  CollectionListViewModel.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import RxSwift

class CollectionListViewModel {
    @Obs.Relay(value: (0..<10).map {
        CollectionExampleCellNodeViewModel(
            image: testImages.randomElement(),
            title: (0...$0).map { "Dummy \($0)" }.joined(separator: " ")
        )
    })
    var listDataObs: Observable<[CollectionExampleCellNodeViewModel]>
}
