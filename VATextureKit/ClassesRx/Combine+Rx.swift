//
//  Combine+Rx.swift
//  VATextureKitRx
//
//  Created by VAndrJ on 05.06.2024.
//

import Combine
import RxSwift

public extension Publisher {

    /// Converts the current `Combine` `publisher` to an `RxSwift` `Observable`.
    ///
    /// - Returns: An `Observable` emitting elements from the `Combine` `publisher`.
    ///
    /// This method allows interoperability between `Combine` and `RxSwift` by converting a `Combine` `publisher` into an `Observable`. The resulting `Observable` emits the elements produced by the original publisher and completes or errors when the publisher does.
    ///
    /// ### Example Usage:
    /// ```swift
    /// let combinePublisher = Just(5)
    /// let observable = combinePublisher.asObservable()
    /// observable.subscribe(onNext: { value in
    ///     print("Received value from Combine publisher: \(value)")
    /// })
    func asObservable() -> Observable<Output> {
        Observable<Output>.create { observer in
            let cancellable = self
                .sink(
                    receiveCompletion: {
                        switch $0 {
                        case .finished:
                            observer.onCompleted()
                        case let .failure(error):
                            observer.onError(error)
                        }
                    },
                    receiveValue: {
                        observer.onNext($0)
                    }
                )

            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
}

public extension Publisher where Failure == Never {

    /// Converts the current `Combine` `publisher` to an `RxSwift` `Infallible`.
    ///
    /// - Returns: An `Infallible` emitting elements from the `Combine` `publisher`.
    ///
    /// This method allows interoperability between `Combine` and `RxSwift` by converting a `Combine` publisher with a failure type of `Never` into an `Infallible`. The resulting `Infallible` emits the elements produced by the original publisher and completes when the publisher does.
    ///
    /// ### Example Usage:
    /// ```swift
    /// let combinePublisher = Just(5)
    /// let infallible = combinePublisher.asInfallible()
    /// infallible.subscribe { event in
    ///     switch event {
    ///     case .next(let value):
    ///         print("Received value from Combine publisher: \(value)")
    ///     case .completed:
    ///         print("Combine publisher completed successfully.")
    ///     }
    /// }
    func asInfallible() -> Infallible<Output> {
        Infallible<Output>.create { observer in
            let cancellable = self
                .sink(
                    receiveCompletion: { _ in
                        observer(.completed)
                    },
                    receiveValue: {
                        observer(.next($0))
                    }
                )

            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
}
