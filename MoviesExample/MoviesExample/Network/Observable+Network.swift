//
//  Observable+Network.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {

    func asMainObservable() -> Observable<Element> {
        observe(on: MainScheduler.instance)
    }

    func handleLoading(_ isLoadingRelay: BehaviorRelay<Bool>?) -> Observable<Element> {
        self.do(
            afterNext: { _ in
                isLoadingRelay?.accept(false)
            },
            afterError: { _ in
                isLoadingRelay?.accept(false)
            },
            onSubscribe: {
                isLoadingRelay?.accept(true)
            },
            onDispose: {
                isLoadingRelay?.accept(false)
            }
        )
    }

    func retryOnNoConnection() -> Observable<Element> {
        retry { $0.recoverOnConnection() }
    }

    func retryOnError() -> Observable<Element> {
        retry(
            .exponentialDelayed(maxCount: 3, initial: 1, multiplier: 3),
            scheduler: MainScheduler.asyncInstance,
            shouldRetry: { error in
                switch error {
                case let error as NetworkError:
                    switch error {
                    case .server, .incorrectEndpointBaseURL, .incorrectEndpointURLComponents, .emptyRequestData, .emptyResponseData:
                        return false
                    case .server500:
                        return true
                    }
                case let error as URLError:
                    return error.code != URLError.Code.notConnectedToInternet
                default:
                    return true
                }
            }
        )
    }
}

extension ObservableConvertibleType where Element == Error {

    func recoverOnConnection() -> Observable<Void> {
        asObservable()
            .map { error in
                if let errorCode = (error as? URLError)?.code, errorCode != URLError.Code.notConnectedToInternet {
                    throw error
                }
            }
            .flatMap {
                ReachabilityService.shared.isConnectionOnlineObs
                    .filter { $0 }
                    .map { _ in }
                    .take(1)
                    .retryOnError()
            }
    }
}
