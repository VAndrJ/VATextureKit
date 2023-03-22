//
//  Obs.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 22.03.2023.
//

import RxSwift
import RxCocoa

public struct Obs {
    
    @propertyWrapper
    public class Stream<Input, Output, InputSequence: ObservableConvertibleType, OutputSequence: ObservableConvertibleType> where InputSequence.Element == Input, OutputSequence.Element == Output {
        public let rx: InputSequence
        public let sequence: OutputSequence
        public var wrappedValue: OutputSequence { sequence }
        
        public init(
            value: Input,
            map: ((InputSequence) -> OutputSequence)? = nil
        ) where InputSequence: BehaviorInitializable, OutputSequence == Observable<InputSequence.Element> {
            let rx = InputSequence.self.init(value: value)
            self.rx = rx
            self.sequence = map?(rx) ?? rx.asObservable()
        }
        
        /// `Input != Output`
        public init(
            value: Input,
            map: ((InputSequence) -> OutputSequence)
        ) where InputSequence: BehaviorInitializable {
            let rx = InputSequence.self.init(value: value)
            self.rx = rx
            self.sequence = map(rx)
        }
        
        public init(map: ((InputSequence) -> OutputSequence)? = nil) where InputSequence: PublishInitializable, OutputSequence == Observable<InputSequence.Element> {
            let rx = InputSequence.self.init()
            self.rx = rx
            self.sequence = map?(rx) ?? rx.asObservable()
        }
        
        /// `Input != Output`
        public init(map: ((InputSequence) -> OutputSequence)) where InputSequence: PublishInitializable {
            let rx = InputSequence.self.init()
            self.rx = rx
            self.sequence = map(rx)
        }
        
        public init(
            replay: ReplayStrategy,
            map: ((InputSequence) -> OutputSequence)? = nil
        ) where InputSequence == ReplaySubject<Output>, OutputSequence == Observable<InputSequence.Element> {
            let rx: ReplaySubject<InputSequence.Element>
            switch replay {
            case .once:
                rx = ReplaySubject.create(bufferSize: 1)
            case .none:
                rx = ReplaySubject.create(bufferSize: 0)
            case let .custom(bufferSize):
                rx = ReplaySubject.create(bufferSize: bufferSize)
            case .all:
                rx = ReplaySubject.createUnbounded()
            }
            self.rx = rx
            self.sequence = map?(rx) ?? rx.asObservable()
        }
        
        /// `Input != Output`
        public init(
            replay: ReplayStrategy,
            map: ((InputSequence) -> OutputSequence)
        ) where InputSequence == ReplaySubject<Input> {
            var rx: ReplaySubject<Input>
            switch replay {
            case .once:
                rx = ReplaySubject.create(bufferSize: 1)
            case .none:
                rx = ReplaySubject.create(bufferSize: 0)
            case let .custom(bufferSize):
                rx = ReplaySubject.create(bufferSize: bufferSize)
            case .all:
                rx = ReplaySubject.createUnbounded()
            }
            self.rx = rx
            self.sequence = map(rx)
        }
    }
    
    @propertyWrapper
    public class Relay<
        Input, Output, InputSequence: ObservableConvertibleType, OutputSequence: ObservableConvertibleType
    >: Stream<Input, Output, InputSequence, OutputSequence> where InputSequence.Element == Input, OutputSequence.Element == Output {
        public override var wrappedValue: OutputSequence { sequence }
        
        public init(value: Input) where InputSequence == BehaviorRelay<Input>, OutputSequence == Observable<InputSequence.Element>, Input == Output {
            super.init(value: value)
        }
        
        public init(value: Input, map: (InputSequence) -> OutputSequence) where InputSequence == BehaviorRelay<Input>, OutputSequence == Observable<Output> {
            super.init(value: value, map: map)
        }
        
        public init() where InputSequence == PublishRelay<Input>, OutputSequence == Observable<InputSequence.Element>, Input == Output {
            super.init()
        }
        
        public init(map: (InputSequence) -> OutputSequence) where InputSequence == PublishRelay<Input>, OutputSequence == Observable<Output> {
            super.init(map: map)
        }
    }
    
    @propertyWrapper
    public class Subject<
        Input, Output, InputSequence: ObservableConvertibleType, OutputSequence: ObservableConvertibleType
    >: Stream<Input, Output, InputSequence, OutputSequence> where InputSequence.Element == Input, OutputSequence.Element == Output {
        public override var wrappedValue: OutputSequence { sequence }
        
        public init(value: Input) where InputSequence == BehaviorSubject<Input>, OutputSequence == Observable<InputSequence.Element>, Input == Output {
            super.init(value: value)
        }
        
        public init(value: Input, map: (InputSequence) -> OutputSequence) where InputSequence == BehaviorSubject<Input>, OutputSequence == Observable<Output> {
            super.init(value: value, map: map)
        }
        
        public init() where InputSequence == PublishSubject<Input>, OutputSequence == Observable<InputSequence.Element>, Input == Output {
            super.init()
        }
        
        public init(map: (InputSequence) -> OutputSequence) where InputSequence == PublishSubject<Input>, OutputSequence == Observable<Output> {
            super.init(map: map)
        }
        
        public init(replay: ReplayStrategy) where Input == Output, InputSequence == ReplaySubject<Input>, OutputSequence == Observable<Output> {
            super.init(replay: replay)
        }
        
        public init(replay: ReplayStrategy, map: (InputSequence) -> OutputSequence) where InputSequence == ReplaySubject<Input>, OutputSequence == Observable<Output> {
            super.init(replay: replay, map: map)
        }
    }

    @propertyWrapper
    public class Single<
        Input, Output, InputSequence: ObservableConvertibleType
    >: Stream<Input, Output, InputSequence, RxSwift.Single<Output>> where InputSequence.Element == Input {
        public override var wrappedValue: RxSwift.Single<Output> { sequence }
        
        public init() where Input == Output, InputSequence == PublishSubject<Input> {
            super.init(map: { $0.asSingle() })
        }
        
        public init(map: @escaping (Input) -> Output) where InputSequence == PublishSubject<Input> {
            super.init(map: { $0.map(map).asSingle() })
        }
        
        public func succeed(_ value: Input) {
            guard let observer = rx as? AnyObserver<Input> else { return }
            observer.onNext(value)
            observer.onCompleted()
        }
    }
    
    @propertyWrapper
    public class Completable: Stream<Never, Never, PublishSubject<Never>, RxSwift.Completable> {
        public override var wrappedValue: RxSwift.Completable { sequence }
        
        public init() {
            super.init(map: { $0.asCompletable() })
        }
        
        public func complete<Element>() -> AnyObserver<Element> {
            AnyObserver { [weak rx] _ in
                rx?.onCompleted()
            }
        }
    }
    
    private init() {}
}

public protocol PublishInitializable: ObservableType {
    init()
}

extension PublishSubject: PublishInitializable {}
extension PublishRelay: PublishInitializable {}

public protocol BehaviorInitializable: ObservableType {
    init(value: Element)
}

extension BehaviorSubject: BehaviorInitializable {}
extension BehaviorRelay: BehaviorInitializable {}

public enum ReplayStrategy {
    case once
    case all
    case custom(Int)
    case none
    
    var count: Int? {
        switch self {
        case .none: return 0
        case .once: return 1
        case let .custom(bufferSize): return bufferSize
        default: return nil
        }
    }
}
