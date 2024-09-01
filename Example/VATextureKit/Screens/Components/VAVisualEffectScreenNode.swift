//
//  VAVisualEffectScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 09.04.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx
import RxSwift
import RxCocoa

struct VAVisualEffectIdentity: DefaultNavigationIdentity {}

class VAVisualEffectScreenNode: ScreenNode, @unchecked Sendable {
    private lazy var imageNode = VAImageNode(
        image: .init(resource: .moon),
        contentMode: .scaleAspectFill
    )
    private lazy var demoNodes = [
        VAMaterialVisualEffectNode.Style.ultraThinMaterial,
        .thickMaterial,
    ].map(_EffectDemonstrationNode.init(style:))
    private lazy var backgroundNode = VAMaterialVisualEffectNode(
        style: .ultraThinMaterial,
        context: .init(
            corner: .init(radius: 24),
            border: .init(color: AppearanceColor(light: .cyan.withAlphaComponent(0.2), dark: .orange.withAlphaComponent(0.2)).wrappedValue),
            shadow: .init(radius: 24),
            neon: .init(color: AppearanceColor(light: .cyan, dark: .orange).wrappedValue, width: 2),
            pointer: .init(radius: 32, color: AppearanceColor(light: .cyan, dark: .orange).wrappedValue),
            excludedFilters: [.luminanceCurveMap, .colorSaturate, .colorBrightness]
        )
    )
    private lazy var materialThicknessSliderNode = _SliderNode(context: .init(title: "Thickness"))
    private lazy var neonSliderNode = _SliderNode(context: .init(maximumValue: 20, value: 2, title: "Neon"))

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(spacing: 16, main: .center, cross: .stretch) {
                Column(spacing: 16, main: .center, cross: .center) {
                    demoNodes
                }
                .padding(.vertical(32))
                .background(backgroundNode)

                materialThicknessSliderNode
                neonSliderNode
            }
            .padding(.horizontal(32))
        }
        .background(imageNode)
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }

    override func bind() {
        materialThicknessSliderNode.valueObs
            .subscribe(onNext: self ?> {
                let thickness = $1
                $0.backgroundNode.child.thickness = thickness
                $0.demoNodes.forEach { $0.effectNode.child.thickness = thickness }
            })
            .disposed(by: bag)
        neonSliderNode.valueObs
            .subscribe(onNext: self ?> {
                let neonWidth = $1
                $0.backgroundNode.child.neonWidth = neonWidth
                $0.demoNodes.forEach { $0.effectNode.child.neonWidth = neonWidth / 2 }
            })
            .disposed(by: bag)
    }
}

private class _SliderNode: VADisplayNode, @unchecked Sendable {
    struct Context {
        var minimumValue: Float = 0
        var maximumValue: Float = 1
        var value: Float = 1
        let title: String
    }

    @MainActor var valueObs: Observable<CGFloat> {
        sliderNode.child.rx.value
            .map(CGFloat.init)
    }

    private let sliderNode: VASizedViewWrapperNode<UISlider>
    private let titleTextNode: VATextNode

    init(context: Context) {
        self.sliderNode = .init(
            childGetter: {
                UISlider().apply {
                    $0.minimumValue = context.minimumValue
                    $0.maximumValue = context.maximumValue
                    $0.value = context.value
                }
            },
            sizing: .viewHeight
        )
        self.titleTextNode = .init(string: context.title, color: { $0.label })

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Row(spacing: 4, cross: .center) {
            titleTextNode
                .flex(basisPercent: 35)
            sliderNode
                .flex(grow: 1)
        }
    }
}

private class _EffectDemonstrationNode: VADisplayNode, @unchecked Sendable {
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
            context: .init(
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
