//
//  MainViewController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit

class MainViewController: VAViewController<MainControllerNode> {
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        
        super.init(node: MainControllerNode())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    private func configure() {
        title = "Examples"
    }
    
    private func bind() {
        contentNode.listNode.dataSource = self
        contentNode.listNode.delegate = self
    }
}

extension MainViewController: ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        viewModel.listData.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let data = viewModel.listData[indexPath.row]
        return {
            MainListCellNode(title: data.title, description: data.description)
        }
    }
}

extension MainViewController: ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(at: indexPath)
        tableNode.deselectRow(at: indexPath, animated: true)
    }
}
