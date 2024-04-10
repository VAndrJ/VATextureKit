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
        context: VAVisualEffectView.Context
    ) {
        super.init(
            effect: UIBlurEffect(style: .init(rawValue: style.rawValue) ?? .systemUltraThinMaterial),
            context: context
        )
    }
}

open class VAVisualEffectNode: VAViewWrapperNode<VAVisualEffectView> {

    public init(effect: UIVisualEffect?, context: VAVisualEffectView.Context) {
        if #available(iOS 13.0, *) {
            super.init(
                actorChildGetter: { VAVisualEffectView(effect: effect, context: context) },
                sizing: nil
            )
        } else {
            super.init(
                childGetter: { VAVisualEffectView(effect: effect, context: context) },
                sizing: nil
            )
        }
    }
}

open class VAVisualEffectView: UIView {
    public struct Corner {
        public let radius: CGFloat
        public var curve: VACornerCurve

        public init(
            radius: CGFloat,
            curve: VACornerCurve = .continuous
        ) {
            self.radius = radius
            self.curve = curve
        }
    }

    public struct Border {
        public let color: UIColor
        /// Defaults to `1 / traitCollection.displayScale`.
        public var width: CGFloat?

        public init(
            color: UIColor,
            width: CGFloat? = nil
        ) {
            self.color = color
            self.width = width
        }
    }

    public struct Neon {
        public let color: UIColor
        public var width: CGFloat = 1

        public init(
            color: UIColor,
            width: CGFloat = 1
        ) {
            self.color = color
            self.width = width
        }
    }

    public struct Shadow {
        public var radius: CGFloat = 16
        public var color: UIColor = .black.withAlphaComponent(0.2)
        public var opacity: Float = 0.4
        public var offset: CGSize = .zero

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

    public struct Pointer {
        public var radius: CGFloat = 22
        public var color: UIColor = .white

        public init(
            radius: CGFloat = 22,
            color: UIColor = .white
        ) {
            self.radius = radius
            self.color = color
        }
    }

    public struct Context {
        let corner: Corner
        let border: Border
        var shadow: Shadow
        var neon: Neon?
        var pointer: Pointer?
        var excludedFilters: [UIVisualEffectViewExcludedFilter]
        var thickness: CGFloat

        public init(
            corner: Corner,
            border: Border,
            shadow: Shadow = .init(),
            neon: Neon? = nil,
            pointer: Pointer? = nil,
            excludedFilters: [UIVisualEffectViewExcludedFilter] = [],
            thickness: CGFloat = 1
        ) {
            self.corner = corner
            self.border = border
            self.shadow = shadow
            self.neon = neon
            self.pointer = pointer
            self.excludedFilters = excludedFilters
            self.thickness = thickness
        }
    }

    public var thickness: CGFloat {
        get { visualEffectView.thickness }
        set {
            visualEffectView.thickness = newValue
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
    public var pointer: Pointer?
    public let visualEffectView: VAThicknessVisualEffectView
    public let neonView = UIView()

    private var pointerView: UIView? {
        didSet { oldValue?.removeFromSuperview() }
    }

    public init(effect: UIVisualEffect?, context: Context) {
        self.corner = context.corner
        self.border = context.border
        self.neon = context.neon
        self.pointer = context.pointer
        self.shadow = context.shadow
        self.visualEffectView = .init(
            effect: effect,
            excludedFilters: context.excludedFilters,
            thickness: context.thickness
        )

        super.init(frame: .init(x: 0, y: 0, width: 240, height: 128))

        addElements()
        configure()
        bind()
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
        neonView.layer.borderColor = neon?.color.withAlphaComponent(thickness).cgColor
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

    @objc private func onPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            let radius = pointer?.radius ?? 22
            let pointerView = UIView(frame: .init(size: .init(same: radius * 2)))
            pointerView.layer.cornerRadius = radius
            pointerView.backgroundColor = pointer?.color.withAlphaComponent(thickness)
            neonView.addSubview(pointerView)
            pointerView.center = sender.location(in: self)
            self.pointerView = pointerView
        case .changed:
            pointerView?.center = sender.location(in: self)
        case .cancelled, .failed, .ended:
            pointerView = nil
        default:
            break
        }
    }

    private func bind() {
        guard pointer != nil else { return }

        isUserInteractionEnabled = true
        addGestureRecognizer(InstantPanGestureRecognizer(
            target: self,
            action: #selector(onPan(_:))
        ))
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

public class VAThicknessVisualEffectView: UIVisualEffectView {
    public var thickness: CGFloat {
        didSet { updateThickness() }
    }

    private var backdropLayer: CALayer? { layer.sublayers?.first }
    private let excludedFilters: [String]
    private let initialEffect: UIVisualEffect?
    private let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear)
    private var filtersObservation: NSKeyValueObservation?

    init(
        effect: UIVisualEffect?,
        excludedFilters: [UIVisualEffectViewExcludedFilter],
        thickness: CGFloat = 1
    ) {
        self.initialEffect = effect
        self.excludedFilters = excludedFilters.map(\.rawValue)
        self.thickness = thickness

        super.init(effect: nil)

        updateAnimator()
        updateThickness()
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

    private func updateThickness() {
        animator.fractionComplete = thickness
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

class InstantPanGestureRecognizer: UIPanGestureRecognizer {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)

        state = .began
    }
}
