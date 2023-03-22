//
//  AlertNodeController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 25.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit

/// ViewController as a View axample
class AlertNodeController: VANodeController {
    let buttonNode = VAButtonNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureTheme(_ theme: VATheme) {
        contentNode.backgroundColor = theme.systemBackground
        buttonNode.setTitle(
            "Show alert",
            with: nil,
            with: theme.systemBlue,
            for: .normal
        )
    }
    
    override func layoutSpec(_ node: ASDisplayNode, _ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                buttonNode
            }
        }
    }
    
    private func showAlert() {
        let alertController = VAAlertController(
            title: "title",
            message: "message",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func bind() {
        buttonNode.onTap = { [weak self] in
            self?.showAlert()
        }
    }
}
