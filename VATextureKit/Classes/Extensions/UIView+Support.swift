//
//  UIView+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import UIKit

public extension UIView {
    
    @inline(__always) @inlinable func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
    
    func addAutolayoutSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
    
    @inline(__always) @inlinable func addAutolayoutSubviews(_ subviews: UIView...) {
        subviews.forEach { addAutolayoutSubview($0) }
    }
    
    @discardableResult
    func toSuperEdges(
        relation: NSLayoutConstraint.Relation = .equal,
        multiplier: CGFloat = 1,
        insets: NSDirectionalEdgeInsets = .zero,
        priority: Float = 1000,
        isSafe: Bool = false,
        isActive: Bool = true,
        configure: (
            _ top: NSLayoutConstraint,
            _ leading: NSLayoutConstraint,
            _ bottom: NSLayoutConstraint,
            _ trailing: NSLayoutConstraint
        ) -> Void = { _, _, _, _ in }
    ) -> UIView {
        var cTop: NSLayoutConstraint!
        var cLeading: NSLayoutConstraint!
        var cBottom: NSLayoutConstraint!
        var cTrailing: NSLayoutConstraint!
        self.toSuper(
            .top,
            relation: relation,
            multiplier: multiplier,
            constant: insets.top,
            priority: priority,
            isSafe: isSafe,
            isActive: isActive,
            configure: { cTop = $0 }
        )
        self.toSuper(
            .leading,
            relation: relation,
            multiplier: multiplier,
            constant: insets.leading,
            priority: priority,
            isSafe: isSafe,
            isActive: isActive,
            configure: { cLeading = $0 }
        )
        self.toSuper(
            .bottom,
            relation: relation,
            multiplier: multiplier,
            constant: insets.bottom,
            priority: priority,
            isSafe: isSafe,
            isActive: isActive,
            configure: { cBottom = $0 }
        )
        self.toSuper(
            .trailing,
            relation: relation,
            multiplier: multiplier,
            constant: insets.trailing,
            priority: priority,
            isSafe: isSafe,
            isActive: isActive,
            configure: { cTrailing = $0 }
        )
        configure(cTop, cLeading, cBottom, cTrailing)

        return self
    }
    
    @discardableResult
    func toSuperAxis(
        _ axis: NSLayoutConstraint.Axis,
        relation: NSLayoutConstraint.Relation = .equal,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0,
        priority: Float = 1000,
        isSafe: Bool = false,
        isActive: Bool = true,
        configure: (_ topOrLeading: NSLayoutConstraint, _ bottomOrTrailing: NSLayoutConstraint) -> Void = { _, _ in }
    ) -> UIView {
        var cTopOrLeading: NSLayoutConstraint!
        var cBottomOrTrailing: NSLayoutConstraint!
        let topOrLeading: NSLayoutConstraint.Attribute
        let bottomOrTrailing: NSLayoutConstraint.Attribute
        switch axis {
        case .horizontal:
            topOrLeading = .leading
            bottomOrTrailing = .trailing
        case .vertical:
            topOrLeading = .top
            bottomOrTrailing = .bottom
        @unknown default:
            fatalError("Implement")
        }
        self.toSuper(
            topOrLeading,
            relation: relation,
            multiplier: multiplier,
            constant: constant,
            priority: priority,
            isSafe: isSafe,
            isActive: isActive,
            configure: { cTopOrLeading = $0 }
        )
        self.toSuper(
            bottomOrTrailing,
            relation: relation,
            multiplier: multiplier,
            constant: -constant,
            priority: priority,
            isSafe: isSafe,
            isActive: isActive,
            configure: { cBottomOrTrailing = $0 }
        )
        configure(cTopOrLeading, cBottomOrTrailing)

        return self
    }
    
    @discardableResult
    func toSuperCenter(
        relation: NSLayoutConstraint.Relation = .equal,
        multiplier: CGFloat = 1,
        offset: CGSize = .zero,
        priority: Float = 1000,
        isSafe: Bool = false,
        isActive: Bool = true,
        configure: (_ centerX: NSLayoutConstraint, _ centerY: NSLayoutConstraint) -> Void = { _, _ in }
    ) -> UIView {
        var cCenterX: NSLayoutConstraint!
        var cCenterY: NSLayoutConstraint!
        self.toSuper(
            .centerX,
            relation: relation,
            multiplier: multiplier,
            constant: offset.width,
            priority: priority,
            isSafe: isSafe,
            isActive: isActive,
            configure: { cCenterX = $0 }
        )
        self.toSuper(
            .centerY,
            relation: relation,
            multiplier: multiplier,
            constant: offset.height,
            priority: priority,
            isSafe: isSafe,
            isActive: isActive,
            configure: { cCenterY = $0 }
        )
        configure(cCenterX, cCenterY)

        return self
    }
    
    @discardableResult
    func toSuper(
        anchors: NSLayoutConstraint.Attribute...,
        relation: NSLayoutConstraint.Relation = .equal,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0,
        priority: Float = 1000,
        isSafe: Bool = false,
        isActive: Bool = true
    ) -> UIView {
        anchors.forEach {
            toSuper(
                $0,
                relation: relation,
                multiplier: multiplier,
                constant: constant,
                priority: priority,
                isSafe: isSafe,
                isActive: isActive,
                configure: { _ in }
            )
        }

        return self
    }
    
    @discardableResult
    func toSuper(
        _ anchor: NSLayoutConstraint.Attribute,
        relation: NSLayoutConstraint.Relation = .equal,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0,
        priority: Float = 1000,
        isSafe: Bool = false,
        isActive: Bool = true,
        configure: (NSLayoutConstraint) -> Void = { _ in }
    ) -> UIView {
        self.anchor(
            anchor,
            sameTo: superview!,
            relation: relation,
            multiplier: multiplier,
            constant: constant,
            priority: priority,
            isSafe: isSafe,
            isActive: isActive,
            configure: configure
        )
    }
    
    @discardableResult
    func anchor(
        _ selfAnchor: NSLayoutConstraint.Attribute,
        opposedTo view: UIView,
        relation: NSLayoutConstraint.Relation = .equal,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0,
        priority: Float = 1000,
        isSafe: Bool = false,
        isActive: Bool = true,
        configure: (NSLayoutConstraint) -> Void = { _ in }
    ) -> UIView {
        let opposedAnchor: NSLayoutConstraint.Attribute
        switch selfAnchor {
        case .bottom:   opposedAnchor = .top
        case .top:      opposedAnchor = .bottom
        case .leading:  opposedAnchor = .trailing
        case .trailing: opposedAnchor = .leading
        case .left:     opposedAnchor = .right
        case .right:    opposedAnchor = .left
        default: fatalError("Implement if needed")
        }

        return self.anchor(
            selfAnchor,
            to: view,
            anchor: opposedAnchor,
            relation: relation,
            multiplier: multiplier,
            constant: constant,
            priority: priority,
            isSafe: isSafe,
            isActive: isActive,
            configure: configure
        )
    }
    
    @discardableResult
    func anchor(
        _ selfAnchor: NSLayoutConstraint.Attribute,
        sameTo view: UIView,
        relation: NSLayoutConstraint.Relation = .equal,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0,
        priority: Float = 1000,
        isSafe: Bool = false,
        isActive: Bool = true,
        configure: (NSLayoutConstraint) -> Void = { _ in }
    ) -> UIView {
        self.anchor(
            selfAnchor,
            to: view,
            anchor: selfAnchor,
            relation: relation,
            multiplier: multiplier,
            constant: constant,
            priority: priority,
            isSafe: isSafe,
            isActive: isActive,
            configure: configure
        )
    }
    
    @discardableResult
    func anchor(
        _ selfAnchor: NSLayoutConstraint.Attribute,
        to view: UIView,
        anchor: NSLayoutConstraint.Attribute,
        relation: NSLayoutConstraint.Relation = .equal,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0,
        priority: Float = 1000,
        isSafe: Bool = false,
        isActive: Bool = true,
        configure: (NSLayoutConstraint) -> Void = { _ in }
    ) -> UIView {
        let toItem = isSafe ? view.safeAreaLayoutGuide : view
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: selfAnchor,
            relatedBy: relation,
            toItem: toItem,
            attribute: anchor,
            multiplier: multiplier,
            constant: constant
        )
        constraint.priority = .init(rawValue: priority)
        constraint.isActive = isActive
        configure(constraint)

        return self
    }
    
    @discardableResult
    func size(
        same constant: CGFloat,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: Float = 1000,
        isActive: Bool = true,
        configure: (_ width: NSLayoutConstraint, _ height: NSLayoutConstraint) -> Void = { _, _ in }
    ) -> UIView {
        var wConstraint: NSLayoutConstraint!
        var hConstraint: NSLayoutConstraint!
        self.size(
            width: constant,
            relation: relation,
            priority: priority,
            isActive: isActive,
            configure: { wConstraint = $0 }
        )
        self.size(
            height: constant,
            relation: relation,
            priority: priority,
            isActive: isActive,
            configure: { hConstraint = $0 }
        )
        configure(wConstraint, hConstraint)

        return self
    }
    
    @discardableResult
    func size(
        _ size: CGSize,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: Float = 1000,
        isActive: Bool = true,
        configure: (_ width: NSLayoutConstraint, _ height: NSLayoutConstraint) -> Void = { _, _ in }
    ) -> UIView {
        var wConstraint: NSLayoutConstraint!
        var hConstraint: NSLayoutConstraint!
        self.size(
            width: size.width,
            relation: relation,
            priority: priority,
            isActive: isActive,
            configure: { wConstraint = $0 }
        )
        self.size(
            height: size.height,
            relation: relation,
            priority: priority,
            isActive: isActive,
            configure: { hConstraint = $0 }
        )
        configure(wConstraint, hConstraint)

        return self
    }
    
    @discardableResult
    func size(
        height: CGFloat,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: Float = 1000,
        isActive: Bool = true,
        configure: (NSLayoutConstraint) -> Void = { _ in }
    ) -> UIView {
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: relation,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: height
        )
        constraint.priority = .init(rawValue: priority)
        constraint.isActive = isActive
        configure(constraint)

        return self
    }
    
    @discardableResult
    func size(
        width: CGFloat,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: Float = 1000,
        isActive: Bool = true,
        configure: (NSLayoutConstraint) -> Void = { _ in }
    ) -> UIView {
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: relation,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: width
        )
        constraint.priority = .init(rawValue: priority)
        constraint.isActive = isActive
        configure(constraint)

        return self
    }
    
    @discardableResult
    func aspectWidth(
        multipliedHeight: CGFloat = 1,
        constant: CGFloat = 0,
        priority: Float = 1000,
        configure: (NSLayoutConstraint) -> Void = { _ in }
    ) -> UIView {
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .height,
            multiplier: multipliedHeight,
            constant: constant
        )
        constraint.priority = .init(rawValue: priority)
        constraint.isActive = true
        configure(constraint)

        return self
    }
    
    @discardableResult
    func aspectHeight(
        multipliedWidth: CGFloat = 1,
        constant: CGFloat = 0,
        priority: Float = 1000,
        configure: (NSLayoutConstraint) -> Void = { _ in }
    ) -> UIView {
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: multipliedWidth,
            constant: constant
        )
        constraint.priority = .init(rawValue: priority)
        constraint.isActive = true
        configure(constraint)
        
        return self
    }
}
