//
//  VAVisualEffectNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 10.04.2024.
//

import UIKit

@available(iOS 13.0, *)
open class VAMaterialVisualEffectNode: VAVisualEffectNode {
    @available(iOS 13.0, *)
    public enum Style: Int, Sendable {
        case ultraThinMaterial = 6
        case thinMaterial = 7
        case regularMaterial = 8
        case thickMaterial = 9
        case chromeMaterial = 10
        case ultraThinMaterialLight = 11
        case thinMaterialLight = 12
        case regularMaterialLight = 13
        case thickMaterialLight = 14
        case chromeMaterialLight = 15
        case ultraThinMaterialDark = 16
        case thinMaterialDark = 17
        case regularMaterialDark = 18
        case thickMaterialDark = 19
        case chromeMaterialDark = 20
    }

    public init(
        style: Style,
        data: VAVisualEffectView.Context
    ) {
        super.init(
            effect: UIBlurEffect(style: .init(rawValue: style.rawValue) ?? .systemUltraThinMaterial),
            data: data
        )
    }
}

open class VAVisualEffectNode: VAViewWrapperNode<VAVisualEffectView> {

    public init(effect: UIVisualEffect?, data: VAVisualEffectView.Context) {
        if #available(iOS 13.0, *) {
            super.init(
                actorChildGetter: { VAVisualEffectView(effect: effect, data: data) },
                sizing: nil
            )
        } else {
            super.init(
                childGetter: { VAVisualEffectView(effect: effect, data: data) },
                sizing: nil
            )
        }
    }
}

open class VAVisualEffectView: UIView {
    public struct Corner {
        let radius: CGFloat
        var curve: VACornerCurve

        public init(
            radius: CGFloat,
            curve: VACornerCurve = .continuous
        ) {
            self.radius = radius
            self.curve = curve
        }
    }
    public struct Border {
        let color: UIColor
        /// Defaults to `1 / traitCollection.displayScale`.
        var width: CGFloat?

        public init(
            color: UIColor,
            width: CGFloat? = nil
        ) {
            self.color = color
            self.width = width
        }
    }
    public struct Neon {
        let color: UIColor
        var width: CGFloat = 1

        public init(
            color: UIColor,
            width: CGFloat = 1
        ) {
            self.color = color
            self.width = width
        }
    }
    public struct Shadow {
        var radius: CGFloat = 16
        var color: UIColor = .black.withAlphaComponent(0.2)
        var opacity: Float = 0.4
        var offset: CGSize = .zero

        public init(
            radius: CGFloat = 16,
            color: UIColor = .black.withAlphaComponent(0.2),
            opacity: Float = 0.4,
            offset: CGSize = .zero
        ) {
            self.radius = radius
            self.color = color
            self.opacity = opacity
            self.offset = offset
        }
    }
    public struct Context {
        let corner: Corner
        let border: Border
        var shadow: Shadow
        var neon: Neon?
        var excludedFilters: [UIVisualEffectViewExcludedFilter]
        var density: CGFloat

        public init(
            corner: VAVisualEffectView.Corner,
            border: VAVisualEffectView.Border,
            shadow: VAVisualEffectView.Shadow = .init(),
            neon: VAVisualEffectView.Neon? = nil,
            excludedFilters: [UIVisualEffectViewExcludedFilter] = [],
            density: CGFloat = 1
        ) {
            self.corner = corner
            self.border = border
            self.shadow = shadow
            self.neon = neon
            self.excludedFilters = excludedFilters
            self.density = density
        }
    }

    public var density: CGFloat {
        get { visualEffectView.density }
        set {
            visualEffectView.density = newValue
            updateColors()
        }
    }
    public var neonWidth: CGFloat {
        get { neon?.width ?? 0 }
        set {
            neon = .init(
                color: neon?.color ?? .clear,
                width: newValue
            )
        }
    }
    public var shadow: Shadow {
        didSet {
            updateShadow()
            guard shadow.color != oldValue.color else { return }

            updateColors()
        }
    }
    public var neon: Neon? {
        didSet {
            updateNeon()
            guard neon?.color != oldValue?.color else { return }

            updateColors()
        }
    }
    public var border: Border {
        didSet {
            updateBorder()
            guard border.color != oldValue.color else { return }

            updateColors()
        }
    }
    public var corner: Corner {
        didSet { updateCorner() }
    }
    public let visualEffectView: VADensityVisualEffectView
    public let neonView = UIView()

    public init(effect: UIVisualEffect?, data: Context) {
        self.corner = data.corner
        self.border = data.border
        self.neon = data.neon
        self.shadow = data.shadow
        self.visualEffectView = .init(
            effect: effect,
            excludedFilters: data.excludedFilters,
            density: data.density
        )

        super.init(frame: .init(x: 0, y: 0, width: 240, height: 128))

        addElements()
        configure()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 12.0, *) {
            guard traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else { return }

            updateColors()
        }
    }

    private func updateColors() {
        layer.borderColor = border.color.cgColor
        neonView.layer.borderColor = neon?.color.withAlphaComponent(density).cgColor
        layer.shadowColor = shadow.color.cgColor
    }

    private func updateCorner() {
        layer.cornerRadius = corner.radius
        neonView.layer.cornerRadius = corner.radius
        neonView.layer.masksToBounds = true
        visualEffectView.layer.cornerRadius = corner.radius
        visualEffectView.layer.masksToBounds = true
        if #available(iOS 13, *) {
            let curve = corner.curve.layerCornerCurve
            layer.cornerCurve = curve
            neonView.layer.cornerCurve = curve
            visualEffectView.layer.cornerCurve = curve
        }
    }

    private func updateBorder() {
        layer.borderWidth = border.width ?? 1 / traitCollection.displayScale
    }

    private func updateNeon() {
        neonView.layer.borderWidth = neon?.width ?? 0
    }

    private func updateShadow() {
        layer.shadowRadius = shadow.radius
        layer.shadowOffset = shadow.offset
        layer.shadowOpacity = shadow.opacity
    }

    private func configure() {
        updateBorder()
        updateCorner()
        updateShadow()
        updateNeon()
        updateColors()
    }

    private func addElements() {
        addAutolayoutSubviews(neonView, visualEffectView)
        neonView
            .toSuperEdges()
        visualEffectView
            .toSuperEdges()
    }
}

public enum UIVisualEffectViewExcludedFilter: String {
    case luminanceCurveMap
    case colorSaturate
    case colorBrightness
    case gaussianBlur
}

public class VADensityVisualEffectView: UIVisualEffectView {
    public var density: CGFloat {
        didSet { updateDensity() }
    }

    private var backdropLayer: CALayer? { layer.sublayers?.first }
    private let excludedFilters: [String]
    private let initialEffect: UIVisualEffect?
    private let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear)
    private var filtersObservation: NSKeyValueObservation?

    init(
        effect: UIVisualEffect?,
        excludedFilters: [UIVisualEffectViewExcludedFilter],
        density: CGFloat = 1
    ) {
        self.initialEffect = effect
        self.excludedFilters = excludedFilters.map(\.rawValue)
        self.density = density

        super.init(effect: nil)

        updateAnimator()
        updateDensity()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateAnimator() {
        animator.stopAnimation(true)
        animator.addAnimations { [weak self] in
            self?.effect = self?.initialEffect
        }
    }

    private func updateDensity() {
        animator.fractionComplete = density
    }

    private func bind() {
        guard !excludedFilters.isEmpty else { return }

        filtersObservation = backdropLayer?.observe(
            \.filters,
             options: [.initial, .new],
             changeHandler: { [excludedFilters] layer, _ in
                 layer.filters?.removeAll(where: {
                     excludedFilters.contains(String(describing: $0))
                 })
             }
        )
    }

    deinit {
        filtersObservation?.invalidate()
        filtersObservation = nil
    }
}
