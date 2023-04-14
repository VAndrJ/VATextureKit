//
//  VAHapticable.swift
//  VATextureKit
//
//  Created by VAndrJ on 14.04.2023.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

public protocol VAHapticable {}

public extension VAHapticable where Self: AnyObject & ReactiveCompatible {

    func bindHaptic(
        style: UIImpactFeedbackGenerator.FeedbackStyle,
        delay: RxTimeInterval,
        triggerObs: Observable<Void>
    ) {
        _ = triggerObs
            .take(until: rx.deallocated)
            .delay(delay, scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: UIImpactFeedbackGenerator(style: style).impactOccurred)
    }
}

public extension VAHapticable where Self: ASDisplayNode {

    func bindTouchHaptic(
        style: UIImpactFeedbackGenerator.FeedbackStyle = .light,
        delay: RxTimeInterval = .seconds(0),
        triggerObs: Observable<Void> = .empty()
    ) {
        bindHaptic(
            style: style,
            delay: delay,
            triggerObs: Observable
                .merge(
                    triggerObs,
                    rx.methodInvoked(#selector(touchesBegan(_:with:)))
                        .map { _ in }
                )
        )
    }
}

public extension VAHapticable where Self: UIView {

    func bindTouchHaptic(
        style: UIImpactFeedbackGenerator.FeedbackStyle = .light,
        delay: RxTimeInterval = .seconds(0),
        triggerObs: Observable<Void> = .empty()
    ) {
        bindHaptic(
            style: style,
            delay: delay,
            triggerObs: Observable
                .merge(
                    triggerObs,
                    rx.methodInvoked(#selector(touchesBegan(_:with:)))
                        .map { _ in }
                )
        )
    }
}
