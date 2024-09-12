//
//  Observable+Support.swift
//  Pods
//
//  Created by VAndrJ on 9/12/24.
//

#if compiler(>=6.0)
public import RxSwift
#else
import RxSwift

extension ObservableType where Element: Sendable {

    public func subscribeMain(
        onNext: (@MainActor @Sendable (Element) -> Void)? = nil,
        onError: (@MainActor @Sendable (any Swift.Error) -> Void)? = nil,
        onCompleted: (@MainActor @Sendable () -> Void)? = nil,
        onDisposed: (@MainActor @Sendable () -> Void)? = nil
    ) -> any Disposable {
        self.observe(on: MainScheduler.instance)
            .subscribe(
                onNext: onNext == nil ? nil : { element in
                    MainActor.assumeIsolated {
                        onNext?(element)
                    }
                },
                onError: onError == nil ? nil : { error in
                    MainActor.assumeIsolated {
                        onError?(error)
                    }
                },
                onCompleted: onCompleted == nil ? nil : {
                    MainActor.assumeIsolated {
                        onCompleted?()
                    }
                },
                onDisposed: onDisposed == nil ? nil : {
                    MainActor.assumeIsolated {
                        onDisposed?()
                    }
                }
            )
    }
}
