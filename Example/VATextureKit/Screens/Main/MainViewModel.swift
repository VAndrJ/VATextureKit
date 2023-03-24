//
//  MainViewModel.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import Foundation
import RxSwift

class MainViewModel {
    @Obs.Relay(value: [
        (title: "Appearance", description: "Select theme", route: NavigationRoute.apearance),
        ("Content size", "Content size category name", .contentSize),
        ("Linear Gradient", "Gradient node examples", .linearGradient),
        ("Radial Gradient", "Gradient node examples", .radialGradient),
        ("Alert", "Alert controller", .alert),
        ("List", "ASCollectionNode based", .collectionList),
    ], map: { $0.map { MainListCellNodeViewModel(title: $0.title, description: $0.description) } })
    var listDataObs: Observable<[MainListCellNodeViewModel]>
    
    private let navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
    }
    
    func didSelect(at index: Int) {
        let route = _listDataObs.rx.value[index].route
        navigator.navigate(to: route)
    }
}
