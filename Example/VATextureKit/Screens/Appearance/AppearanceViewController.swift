//
//  AppearanceViewController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

// MARK: - ViewController with Node example

final class AppearanceViewController: VAViewController<AppearanceContollerNode> {
    let viewModel: AppearanceViewModel
    
    init(viewModel: AppearanceViewModel) {
        self.viewModel = viewModel
        
        super.init(node: AppearanceContollerNode())
    }
    
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
        contentNode.pickerNode.child.selectRow(viewModel.currentTheme.rawValue, inComponent: 0, animated: false)
    }
}

// MARK: - UIPickerViewDataSource

extension AppearanceViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.themes.count
    }
}

// MARK: - UIPickerViewDelegate

extension AppearanceViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(viewModel.themes[row])".capitalized
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.didSelect(at: row)
    }
}
