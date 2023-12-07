//
//  VAHapticable.swift
//  VATextureKitRx
//
//  Created by Volodymyr Andriienko on 14.04.2023.
//

import VATextureKit
import RxSwift
import RxCocoa

public protocol VAHapticable {}

public extension VAHapticable where Self: AnyObject & ReactiveCompatible {

    @MainActor
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

    @MainActor
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

    @MainActor
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
