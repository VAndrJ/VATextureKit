//
//  StackLayoutControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class StackLayoutControllerNode: VASafeAreaDisplayNode {
    private var pairNodes: [ASDisplayNode] { [ASDisplayNode().sized(CGSize(same: 128)), ASDisplayNode().sized(CGSize(same: 64))] }
    private func getTitleTextNode(string: String) -> VATextNode {
        let fontDesign: VAFontDesign
        if #available(iOS 13.0, *) {
            fontDesign = .monospaced
        } else {
            fontDesign = .default
        }
        return VATextNode(
            string: string,
            color: { $0.label },
            descriptor: fontDesign
        )
    }
    private lazy var stackTitleTextNode = getTitleTextNode(string: "Stack with 2 elements")
    private lazy var stackCenteredElementTitleTextNode = getTitleTextNode(string: "Stack with 2 elements, second is centered")
    private lazy var stackRelativeElementTitleTextNode = getTitleTextNode(string: "Stack with 2 elements, second is relatively")
    private lazy var defaultPairNodes = pairNodes
    private lazy var centeredPairNodes = pairNodes
    private lazy var relativePairNodes = pairNodes
    private lazy var scrollNode = VAScrollNode(data: .init(contentInset: UIEdgeInsets(vertical: 24)))
    private lazy var centeringButtonNode = VAButtonNode()
    private lazy var relativeHorizontalPositionButtonNode = VAButtonNode()
    private lazy var relativeVerticalPositionButtonNode = VAButtonNode()
    private lazy var centeringInfoTextNode = VATextNode(
        text: centeringOptions.description,
        fontStyle: .headline
    )
    private lazy var relativePositionHorizontalInfoTextNode = VATextNode(
        text: relativeHorizontalPosition.horizontalDescription,
        fontStyle: .headline
    )
    private lazy var relativePositionVerticalInfoTextNode = VATextNode(
        text: relativeHorizontalPosition.verticalDescription,
        fontStyle: .headline
    )

    private var centeringOptions: ASCenterLayoutSpecCenteringOptions = .XY {
        didSet {
            scrollNode.setNeedsLayoutAnimated()
            centeringInfoTextNode.text = centeringOptions.description
        }
    }
    private var relativeHorizontalPosition: ASRelativeLayoutSpecPosition = .end {
        didSet {
            scrollNode.setNeedsLayoutAnimated()
            relativePositionHorizontalInfoTextNode.text = relativeHorizontalPosition.horizontalDescription
        }
    }
    private var relativeVerticalPosition: ASRelativeLayoutSpecPosition = .end {
        didSet {
            scrollNode.setNeedsLayoutAnimated()
            relativePositionVerticalInfoTextNode.text = relativeVerticalPosition.verticalDescription
        }
    }

    override init() {
        super.init()

        scrollNode.layoutSpecBlock = { [weak self] in
            self?.layoutSpecScroll(constrainedSize: $1) ?? ASLayoutSpec()
        }
    }

    override func didLoad() {
        super.didLoad()

        bind()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            scrollNode
        }
    }

    func layoutSpecScroll(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 16) {
            stackTitleTextNode
                .padding(.top(24))
            Stack {
                defaultPairNodes
            }

            stackCenteredElementTitleTextNode
                .padding(.top(24))
            Column {
                centeringButtonNode
                centeringInfoTextNode
            }
            Stack {
                centeredPairNodes[0]
                centeredPairNodes[1]
                    .centered(centeringOptions)
            }

            stackRelativeElementTitleTextNode
                .padding(.top(24))
            Column {
                relativeHorizontalPositionButtonNode
                relativePositionHorizontalInfoTextNode
                relativeVerticalPositionButtonNode
                relativePositionVerticalInfoTextNode
            }
            Stack {
                relativePairNodes[0]
                relativePairNodes[1]
                    .relatively(horizontal: relativeHorizontalPosition, vertical: relativeVerticalPosition)
            }
        }
        .padding(.horizontal(16))
    }

    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        animateLayoutTransition(context: context)
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        zip(defaultPairNodes, [theme.label, theme.systemOrange]).forEach {
            $0.0.backgroundColor = $0.1
        }
        zip(centeredPairNodes, [theme.label, theme.systemOrange]).forEach {
            $0.0.backgroundColor = $0.1
        }
        zip(relativePairNodes, [theme.label, theme.systemOrange]).forEach {
            $0.0.backgroundColor = $0.1
        }
        centeringButtonNode.configure(title: "Change centering", theme: theme)
        relativeHorizontalPositionButtonNode.configure(title: "Change horizontal", theme: theme)
        relativeVerticalPositionButtonNode.configure(title: "Change vertical", theme: theme)
    }

    private func bind() {
        centeringButtonNode.onTap = self ?> { $0.centeringOptions.toggle() }
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
