//
//  CollectionListDifferentCellsViewModel.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 24.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import Foundation
import RxSwift

class CollectionListDifferentCellsViewModel {
    @Obs.Relay(value: [
        LoadingCellNodeViewModel(),
    ])
    var listDataObs: Observable<[CellViewModel]>
    
    private var count = 0
    
    func checkMore() -> Bool {
        count < .max
    }
    
    func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            count += 1
            var data = _listDataObs.rx.value
            var more: CellViewModel?
            if data.last is LoadingCellNodeViewModel {
                more = data.removeLast()
            }
            data.append(contentsOf: [
                MainListCellNodeViewModel(title: "Title \(count)", description: "Description \(count)"),
                ImageCellNodeViewModel(image: testImages.randomElement()),
                ImageCellNodeViewModel(image: testImages.randomElement(), ratio: 2),
                ImageCellNodeViewModel(image: testImages.randomElement(), ratio: 1.0 / 2),
                ImageNumberCellNodeViewModel(image: testImages.randomElement(), number: 1),
                ImageNumberCellNodeViewModel(image: testImages.randomElement(), ratio: 2, number: 2),
                ImageNumberCellNodeViewModel(image: testImages.randomElement(), ratio: 1.0 / 2, number: 3),
            ])
            if checkMore() {
                data.append(more ?? LoadingCellNodeViewModel())
            }
            _listDataObs.rx.accept(data)
        }
    }
}
