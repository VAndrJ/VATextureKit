//
//  ContentSizeViewController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class ContentSizeViewController: VAViewController<ContentSizeScreenNode> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        title = "Content size"
        updateContentSizeLabel()
    }

    override func configureContentSize(_ contentSize: UIContentSizeCategory) {
        updateContentSizeLabel()
    }
    
    private func updateContentSizeLabel() {
        contentNode.contentSizeTextNode.text = appContext.contentSizeManager.contentSize.rawValue
    }
}
