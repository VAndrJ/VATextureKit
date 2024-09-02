//
//  CollectionListDifferentCellsViewModel.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 24.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx
import RxSwift
import RxCocoa

final class CollectionListDifferentCellsViewModel: @unchecked Sendable {
    @Obs.Relay(value: false)
    var isLoadingObs: Observable<Bool>
    @Obs.Relay(value: [
        LoadingCellNodeViewModel(),
    ])
    var listDataObs: Observable<[CellViewModel]>
    
    private var count = 0
    
    func checkMoreAvailable() -> Bool {
        count < 3
    }

    func reloadData() {
        _isLoadingObs.rx.accept(true)
        mainAsync(after: 3) {
            count = 0
            _listDataObs.rx.accept([
                LoadingCellNodeViewModel(),
            ])
            _isLoadingObs.rx.accept(false)
        }
    }
    
    func loadMore() {
        mainAsync(after: 3) {
            count += 1
            var data = _listDataObs.rx.value
            var more: CellViewModel?
            if data.last is LoadingCellNodeViewModel {
                more = data.removeLast()
            }
            data.append(contentsOf: [
                MainListCellNodeViewModel(title: "Title \(count)", description: "Description \(count)", destination: AlertNavigationIdentity()),
                ImageCellNodeViewModel(image: testImages.randomElement()),
                ImageCellNodeViewModel(image: testImages.randomElement(), ratio: 2),
                ImageCellNodeViewModel(image: testImages.randomElement(), ratio: 1.0 / 2),
                ImageNumberCellNodeViewModel(image: testImages.randomElement(), number: 1),
                ImageNumberCellNodeViewModel(image: testImages.randomElement(), ratio: 2, number: 2),
                ImageNumberCellNodeViewModel(image: testImages.randomElement(), ratio: 1.0 / 2, number: 3),
            ])
            if checkMoreAvailable() {
                data.append(more ?? LoadingCellNodeViewModel())
            }
            _listDataObs.rx.accept(data)
        }
    }
}
