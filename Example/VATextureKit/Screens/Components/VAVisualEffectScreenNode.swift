//
//  VAVisualEffectScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 09.04.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

struct VAVisualEffectIdentity: DefaultNavigationIdentity {}

class VAVisualEffectScreenNode: ScreenNode {
    private lazy var imageNode = VAImageNode(
        image: R.image.colibri(),
        contentMode: .scaleAspectFill
    )
    private lazy var demoNodes = [
        VAMaterialVisualEffectNode.Style.ultraThinMaterial,
        .regularMaterial,
    ].map(_EffectDemonstrationNode.init(style:))
    private lazy var backgroundNode = VAMaterialVisualEffectNode(
        style: .ultraThinMaterial,
        data: .init(
            corner: .init(radius: 24),
            border: .init(color: AppearanceColor(light: .cyan.withAlphaComponent(0.2), dark: .orange.withAlphaComponent(0.2)).wrappedValue),
            shadow: .init(radius: 24),
            neon: .init(color: AppearanceColor(light: .cyan, dark: .orange).wrappedValue, width: 2),
            excludedFilters: [.luminanceCurveMap, .colorSaturate, .colorBrightness]
        )
    )
    private lazy var materialDensitySliderNode = VASizedViewWrapperNode(
        actorChildGetter: { UISlider().apply { $0.value = 1 } },
        sizing: .viewHeight
    )
    private lazy var neonSliderNode = VASizedViewWrapperNode(
        actorChildGetter: {
            UISlider().apply {
                $0.value = 2
                $0.minimumValue = 0
                $0.maximumValue = 20
            }
        },
        sizing: .viewHeight
    )

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(spacing: 32, main: .center, cross: .center) {
                Column(spacing: 16, main: .center, cross: .center) {
                    demoNodes
                }
                .padding(.all(48))
                .background(backgroundNode)

                materialDensitySliderNode
                    .padding(.horizontal(32))
                neonSliderNode
                    .padding(.horizontal(32))
            }
        }
        .background(imageNode)
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }

    override func bind() {
        materialDensitySliderNode.child.rx.value
            .map(CGFloat.init)
            .subscribe(onNext: self ?> {
                let density = $1
                $0.backgroundNode.child.density = density
                $0.demoNodes.forEach { $0.effectNode.child.density = density }
            })
            .disposed(by: bag)
        neonSliderNode.child.rx.value
            .map(CGFloat.init)
            .subscribe(onNext: self ?> {
                let neonWidth = $1
                $0.backgroundNode.child.neonWidth = neonWidth
                $0.demoNodes.forEach { $0.effectNode.child.neonWidth = neonWidth / 2 }
            })
            .disposed(by: bag)
    }
}

private class _EffectDemonstrationNode: VADisplayNode {
    let effectNode: VAMaterialVisualEffectNode

    private let textNode: VATextNode

    convenience init(style: VAMaterialVisualEffectNode.Style) {
        self.init(style: style, excludedFilters: [])
    }

    init(
        style: VAMaterialVisualEffectNode.Style,
        excludedFilters: [UIVisualEffectViewExcludedFilter]
    ) {
        @AppearanceColor(light: .white.withAlphaComponent(0.4), dark: .white.withAlphaComponent(0.2))
        var borderColor: UIColor
        self.effectNode = .init(
            style: style,
            data: .init(
                corner: .init(radius: 16),
                border: .init(color: borderColor),
                neon: .init(color: AppearanceColor(light: .cyan, dark: .orange).wrappedValue, width: 2),
                excludedFilters: excludedFilters
            )
        )
        self.textNode = .init(string: String(describing: style), color: { $0.label })

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        textNode
            .padding(.all(16))
            .background(effectNode)
    }
}
