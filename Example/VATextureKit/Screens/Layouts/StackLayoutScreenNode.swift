//
//  StackLayoutScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct StackLayoutNavigationIdentity: DefaultNavigationIdentity {}

final class StackLayoutScreenNode: ScrollScreenNode, @unchecked Sendable {
    private lazy var stackLayoutExampleNode = _StackLayoutExampleNode()
    private lazy var stackCenteringLayoutExampleNode = _StackCenteringLayoutExampleNode()
    private lazy var stackPositionsLayoutExampleNode = _StackPositionsLayoutExampleNode()

    override func scrollLayoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 32, cross: .stretch) {
            stackLayoutExampleNode
            stackCenteringLayoutExampleNode
            stackPositionsLayoutExampleNode
        }
        .padding(.all(16))
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.secondarySystemBackground
    }
}

private class _StackLayoutExampleNode: DisplayNode, @unchecked Sendable {
    private lazy var titleTextNode = getTitleTextNode(
        string: "Stack with 2 elements, second is relatively",
        selection: "relatively"
    )
    private lazy var pairNodes = [
        ASDisplayNode().sized(.init(same: 128)),
        ASDisplayNode().sized(.init(same: 64)),
    ]

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 8) {
            titleTextNode
            Stack {
                pairNodes[0]
                pairNodes[1]
                    .padding(.all(4))
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        zip(pairNodes, [theme.label, theme.systemOrange]).forEach {
            $0.0.backgroundColor = $0.1
        }
    }
}

private class _StackCenteringLayoutExampleNode: DisplayNode, @unchecked Sendable {
    private lazy var titleTextNode = getTitleTextNode(
        string: "Stack with 2 elements, second is centered",
        selection: "centered"
    )
    private lazy var centeringInfoTextNode = VATextNode(
        text: centeringOptions.description,
        fontStyle: .headline
    ).apply {
        $0.displaysAsynchronously = false
    }
    private lazy var pairNodes = [
        ASDisplayNode().sized(.init(same: 128)),
        ASDisplayNode().sized(.init(same: 64)),
    ]
    private lazy var centeringButtonNode = HapticButtonNode(title: "Change centering")
    private var centeringOptions: ASCenterLayoutSpecCenteringOptions = .XY {
        didSet {
            setNeedsLayoutAnimated()
            centeringInfoTextNode.text = centeringOptions.description
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 8) {
            titleTextNode
            Column {
                centeringButtonNode
                centeringInfoTextNode
            }
            Stack {
                pairNodes[0]
                pairNodes[1]
                    .padding(.all(4))
                    .centered(centeringOptions)
            }
        }
    }

    override func viewDidAnimateLayoutTransition(_ context: any ASContextTransitioning) {
        animateLayoutTransition(context: context)
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        zip(pairNodes, [theme.label, theme.systemOrange]).forEach {
            $0.0.backgroundColor = $0.1
        }
    }

    override func bind() {
        centeringButtonNode.onTap = self ?> { $0.centeringOptions.toggle() }
    }
}

private class _StackPositionsLayoutExampleNode: DisplayNode, @unchecked Sendable {
    private lazy var titleTextNode = getTitleTextNode(
        string: "Stack with 2 elements, second is relatively",
        selection: "relatively"
    )
    private lazy var pairNodes = [
        ASDisplayNode().sized(.init(same: 128)),
        ASDisplayNode().sized(.init(same: 64)),
    ]
    private lazy var relativeHorizontalPositionButtonNode = HapticButtonNode(title: "Change horizontal")
    private lazy var relativeVerticalPositionButtonNode = HapticButtonNode(title: "Change vertical")
    private lazy var relativePositionHorizontalInfoTextNode = VATextNode(
        text: relativeHorizontalPosition.horizontalDescription,
        fontStyle: .headline
    ).apply {
        $0.displaysAsynchronously = false
    }
    private lazy var relativePositionVerticalInfoTextNode = VATextNode(
        text: relativeHorizontalPosition.verticalDescription,
        fontStyle: .headline
    ).apply {
        $0.displaysAsynchronously = false
    }
    private var relativeHorizontalPosition: ASRelativeLayoutSpecPosition = .end {
        didSet {
            setNeedsLayoutAnimated()
            relativePositionHorizontalInfoTextNode.text = relativeHorizontalPosition.horizontalDescription
        }
    }
    private var relativeVerticalPosition: ASRelativeLayoutSpecPosition = .end {
        didSet {
            setNeedsLayoutAnimated()
            relativePositionVerticalInfoTextNode.text = relativeVerticalPosition.verticalDescription
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 8) {
            titleTextNode
            Column {
                relativeHorizontalPositionButtonNode
                relativePositionHorizontalInfoTextNode
                relativeVerticalPositionButtonNode
                relativePositionVerticalInfoTextNode
            }
            Stack {
                pairNodes[0]
                pairNodes[1]
                    .padding(.all(4))
                    .relatively(horizontal: relativeHorizontalPosition, vertical: relativeVerticalPosition)
            }
        }
    }

    override func viewDidAnimateLayoutTransition(_ context: any ASContextTransitioning) {
        animateLayoutTransition(context: context)
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        zip(pairNodes, [theme.label, theme.systemOrange]).forEach {
            $0.0.backgroundColor = $0.1
        }
    }

    override func bind() {
        relativeHorizontalPositionButtonNode.onTap = self ?> { $0.relativeHorizontalPosition.toggle() }
        relativeVerticalPositionButtonNode.onTap = self ?> { $0.relativeVerticalPosition.toggle() }
    }
}

private extension ASCenterLayoutSpecCenteringOptions {
    var description: String {
        let string: String
        switch self {
        case .X: string = ".X"
        case .XY: string = ".XY"
        case .Y: string = ".Y"
        default: string = ".none"
        }

        return "Centering: \(string)"
    }
    var toggled: Self {
        switch self {
        case .X: return .Y
        case .Y: return .XY
        default: return .X
        }
    }

    mutating func toggle() {
        self = toggled
    }
}

private extension ASRelativeLayoutSpecPosition {
    var horizontalDescription: String { "Horizontal: \(description)" }
    var verticalDescription: String { "Vertical: \(description)" }
    var description: String {
        let string: String
        switch self {
        case .start: string = ".start"
        case .end: string = ".end"
        case .center: string = ".center"
        default: string = ".none"
        }
        
        return string
    }
    var toggled: Self {
        switch self {
        case .start: return .center
        case .center: return .end
        default: return .start
        }
    }

    mutating func toggle() {
        self = toggled
    }
}
