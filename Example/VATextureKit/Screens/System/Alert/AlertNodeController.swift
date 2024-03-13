//
//  AlertNodeController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 25.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct AlertNavigationIdentity: DefaultNavigationIdentity {}

// MARK: - ViewController as a View axample

final class AlertNodeController: VANodeController {

    // MARK: - UI related code

    private let buttonNode = HapticButtonNode(title: "Show alert")

    override func layoutSpec(_ node: ASDisplayNode, _ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                buttonNode
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)

        contentNode.backgroundColor = theme.systemBackground
    }

    // MARK: - Controller related code

    private func showAlert() {
        let alertController = VAAlertController(
            title: "title",
            message: "message",
            preferredStyle: .alert,
            actions: UIAlertAction(title: "OK", style: .cancel)
        )
        present(alertController, animated: true)
    }
    
    override func bind() {
        buttonNode.onTap = self ?>> { $0.showAlert }
    }
}
