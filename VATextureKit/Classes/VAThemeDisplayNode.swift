//
//  VAThemeDisplayNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

open class VAThemeDisplayNode<Theme>: VADisplayNode {
    public let themeManager: VAThemeManager<Theme>
    
    public required init(themeManager: VAThemeManager<Theme>) {
        self.themeManager = themeManager
        
        super.init()
    }
    
    open override func didLoad() {
        configureTheme()
        
        super.didLoad()
    }
    
    open override func themeDidChanged() {
        configureTheme()
    }
    
    open func configureTheme() {}
}
