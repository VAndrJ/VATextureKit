//
//  Pub.swift
//  Differentiator
//
//  Created by VAndrJ on 05.06.2024.
//

import Combine

public enum Pub {

    @propertyWrapper
    public class Stream<Input, Output, FailureIn, FailureOut, InputPublisher: Publisher, OutputPublisher: Publisher> where InputPublisher.Output == Input, OutputPublisher.Output == Output {
        public let inputPublisher: InputPublisher
        public let outputPublisher: OutputPublisher
        public var wrappedValue: OutputPublisher { outputPublisher }

        /// Where `Input == Output`, `FailureIn == FailureOut`
        public init(_ value: Input) where InputPublisher: CurrentValueSubject<Input, FailureIn>, OutputPublisher == AnyPublisher<Output, FailureOut>, Input == Output, FailureIn == FailureOut {
            let inputPublisher = InputPublisher.self.init(value)
            self.inputPublisher = inputPublisher
            self.outputPublisher = inputPublisher.eraseToAnyPublisher()
        }

        public init(
            _ value: Input,
            map: ((InputPublisher) -> OutputPublisher)
        ) where InputPublisher: CurrentValueSubject<Input, FailureIn> {
            let inputPublisher = InputPublisher.self.init(value)
            self.inputPublisher = inputPublisher
            self.outputPublisher = map(inputPublisher)
        }

        /// Where `Input == Output`, `FailureIn == FailureOut`
        public init() where InputPublisher: PassthroughSubject<Input, FailureIn>, OutputPublisher == AnyPublisher<Output, FailureOut>, Input == Output, FailureIn == FailureOut {
            let inputPublisher = InputPublisher.self.init()
            self.inputPublisher = inputPublisher
            self.outputPublisher = inputPublisher.eraseToAnyPublisher()
        }

        public init(map: (InputPublisher) -> OutputPublisher) where InputPublisher: PassthroughSubject<Input, FailureIn> {
            let inputPublisher = InputPublisher.self.init()
            self.inputPublisher = inputPublisher
            self.outputPublisher = map(inputPublisher)
        }

        public func send(_ input: Input) where InputPublisher: PassthroughSubject<Input, FailureIn> {
            inputPublisher.send(input)
        }

        public func send() where InputPublisher: PassthroughSubject<Input, FailureIn>, Input == Void {
            inputPublisher.send()
        }

        public func send(_ input: Input) where InputPublisher: CurrentValueSubject<Input, FailureIn> {
            inputPublisher.send(input)
        }

        public func send(completion: Subscribers.Completion<FailureIn>) where InputPublisher: PassthroughSubject<Input, FailureIn> {
            inputPublisher.send(completion: completion)
        }

        public func send(completion: Subscribers.Completion<FailureIn>) where InputPublisher: CurrentValueSubject<Input, FailureIn> {
            inputPublisher.send(completion: completion)
        }
    }

    @propertyWrapper
    public final class Subject<
        Input, Output, FailureIn, FailureOut, InputPublisher: Publisher, OutputPublisher: Publisher
    >: Stream<Input, Output, FailureIn, FailureOut, InputPublisher, OutputPublisher> where InputPublisher.Output == Input, OutputPublisher.Output == Output {
        public override var wrappedValue: OutputPublisher { super.wrappedValue }

        public init(_ value: Input) where InputPublisher == CurrentValueSubject<Input, FailureIn>, OutputPublisher == AnyPublisher<InputPublisher.Output, FailureOut>, Input == Output, FailureIn == FailureOut {
            super.init(value)
        }

        public init(
            _ value: Input,
            map: @escaping (Input) -> Output
        ) where InputPublisher == CurrentValueSubject<Input, FailureIn>, OutputPublisher == AnyPublisher<Output, FailureOut>, FailureIn == FailureOut {
            super.init(value, map: { $0.map(map).eraseToAnyPublisher() })
        }

        public init(
            _ value: Input,
            mapError: @escaping (FailureIn) -> FailureOut
        ) where InputPublisher == CurrentValueSubject<Input, FailureIn>, OutputPublisher == AnyPublisher<Output, FailureOut>, Input == Output {
            super.init(value, map: { $0.mapError(mapError).eraseToAnyPublisher() })
        }

        public init(
            _ value: Input,
            map: @escaping (Input) -> Output,
            mapError: @escaping (FailureIn) -> FailureOut
        ) where InputPublisher == CurrentValueSubject<Input, FailureIn>, OutputPublisher == AnyPublisher<Output, FailureOut> {
            super.init(value, map: { $0.map(map).mapError(mapError).eraseToAnyPublisher() })
        }

        public init() where InputPublisher == PassthroughSubject<Input, FailureIn>, OutputPublisher == AnyPublisher<InputPublisher.Output, FailureOut>, Input == Output, FailureIn == FailureOut {
            super.init()
        }

        public init(map: @escaping (Input) -> Output) where InputPublisher == PassthroughSubject<Input, FailureIn>, OutputPublisher == AnyPublisher<Output, FailureOut>, FailureIn == FailureOut {
            super.init(map: { $0.map(map).eraseToAnyPublisher() })
        }

        public init(mapError: @escaping (FailureIn) -> FailureOut) where InputPublisher == PassthroughSubject<Input, FailureIn>, OutputPublisher == AnyPublisher<Output, FailureOut>, Input == Output {
            super.init(map: { $0.mapError(mapError).eraseToAnyPublisher() })
        }

        public init(
            map: @escaping (Input) -> Output,
            mapError: @escaping (FailureIn) -> FailureOut
        ) where InputPublisher == PassthroughSubject<Input, FailureIn>, OutputPublisher == AnyPublisher<Output, FailureOut> {
            super.init(map: { $0.map(map).mapError(mapError).eraseToAnyPublisher() })
        }
    }
}

public extension Pub.Subject where InputPublisher == CurrentValueSubject<Input, FailureIn>, Input == Output {
    var value: Output { inputPublisher.value }
}
