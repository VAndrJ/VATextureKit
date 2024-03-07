//
//  TypingTextControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct TypingTextNavigationIdentity: DefaultNavigationIdentity {}

final class TypingTextControllerNode: VASafeAreaDisplayNode {
    private lazy var typingTextNode = VATypingTextNode(text: .loremText)
    private lazy var startTypingButtonNode = HapticButtonNode(title: "Start typing")
    private lazy var pauseTypingButtonNode = HapticButtonNode(title: "Pause typing")
    private lazy var resetTypingButtonNode = HapticButtonNode(title: "Reset typing")
    private lazy var eraseAndRetypeButtonNode = HapticButtonNode(title: "Erase and retype")

    override func didLoad() {
        super.didLoad()

        bind()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                startTypingButtonNode
                pauseTypingButtonNode
                resetTypingButtonNode
                eraseAndRetypeButtonNode
                typingTextNode
                    .padding(.top(16))
            }
            .padding(.all(16))
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }

    private func bind() {
        startTypingButtonNode.onTap = self ?>> { $0.typingTextNode.startTyping }
        pauseTypingButtonNode.onTap = self ?>> { $0.typingTextNode.pauseTyping }
        resetTypingButtonNode.onTap = self ?>> { $0.typingTextNode.resetTyping }
        eraseAndRetypeButtonNode.onTap = self ?> { $0.typingTextNode.startRetyping(to: "Retyped: " + .loremText) }
    }
}
