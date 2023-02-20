//
//  MainViewModel.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import Foundation

class MainViewModel {
    let listData: [(title: String, description: String, route: NavigationRoute)] = [
        ("Appearance", "Select theme", .apearance)
    ]
    
    private let navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
    }
    
    func didSelect(at index: Int) {
        let route = listData[index].route
        navigator.navigate(to: route)
    }
}
