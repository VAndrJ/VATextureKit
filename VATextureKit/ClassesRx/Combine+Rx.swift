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
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            observer.onCompleted()
                        case let .failure(error):
                            observer.onError(error)
                        }
                    },
                    receiveValue: { value in
                        observer.onNext(value)
                    }
                )

            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
}
