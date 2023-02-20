//
//  AppearanceController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit

class AppearanceController: VAViewController<AppearanceContollerNode> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    private func configure() {
        title = "Appearance"
    }
    
    private func bind() {
        contentNode.pickerNode.child.dataSource = self
        contentNode.pickerNode.child.delegate = self
        contentNode.pickerNode.child.selectRow(ThemeManager.shared.currentTheme.rawValue, inComponent: 0, animated: false)
    }
}

extension AppearanceController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Theme.allCases.count
    }
}

extension AppearanceController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Theme(rawValue: row).flatMap { "\($0)" }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Theme(rawValue: row).flatMap { ThemeManager.shared.update(theme: $0) }
    }
}
