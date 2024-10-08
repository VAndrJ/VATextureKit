//
//  CollectionListHeaderFooterViewModel.swift
//  VATextureKit_Tests
//
//  Created by Volodymyr Andriienko on 22.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx
import RxSwift
import RxCocoa
import Differentiator

final class CollectionListHeaderFooterViewModel: @unchecked Sendable {
    @Obs.Relay(value: [
        AnimatableSectionModel(
            model: CollectionListSectionHeaderFooterViewModel(
                headerViewModel: CollectionListSectionHeaderViewModel(title: "Header"),
                footerViewModel: CollectionListSectionFooterViewModel(title: "Footer")
            ),
            items: (0...25).map { ImageNumberCellNodeViewModel(image: testImages.randomElement(), ratio: 1 / 4, number: $0) }
        ),
    ])
    var listDataObs: Observable<[AnimatableSectionModel<CollectionListSectionHeaderFooterViewModel, CellViewModel>]>

    func moveItem(source: IndexPath, destination: IndexPath) {
        var data = _listDataObs.value
        let item = data[source.section].items.remove(at: source.item)
        data[destination.section].items.insert(item, at: destination.item)
        _listDataObs.rx.accept(data)
    }
}

final class CollectionListSectionHeaderFooterViewModel: CellViewModel {
    let headerViewModel: CollectionListSectionHeaderViewModel?
    let footerViewModel: CollectionListSectionFooterViewModel?

    init(
        headerViewModel: CollectionListSectionHeaderViewModel? = nil,
        footerViewModel: CollectionListSectionFooterViewModel? = nil
    ) {
        self.headerViewModel = headerViewModel
        self.footerViewModel = footerViewModel
    }
}
