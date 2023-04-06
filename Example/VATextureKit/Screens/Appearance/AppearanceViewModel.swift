//
//  AppearanceViewModel.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

class AppearanceViewModel {
    let themes = Theme.allCases
    var currentTheme: Theme { themeManager.currentTheme }
    
    private let themeManager: ThemeManager
    
    init(themeManager: ThemeManager) {
        self.themeManager = themeManager
    }
    
    func didSelect(at index: Int) {
        themeManager.update(theme: themes[index])
    }
}
