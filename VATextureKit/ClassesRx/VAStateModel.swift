//
//  VAStateModel.swift
//  VATextureKitRx
//
//  Created by Volodymyr Andriienko on 25.03.2023.
//

#if compiler(>=6.0)
public import RxSwift
#else
import RxSwift
#endif
import VATextureKit
import RxCocoa

open class VAStateModel<Action, Event, State>: NSObject {
    public let bag = DisposeBag()
    public var state: State { stateRelay.value }
    public var stateObs: Observable<State> { stateRelay.asObservable() }
    
    private let stateRelay: BehaviorRelay<State>
    private let eventRelay = PublishRelay<Event>()
    private let actionRelay = PublishRelay<Action>()
    private let actionScheduler: any ImmediateSchedulerType
    private let eventScheduler: any ImmediateSchedulerType
    
    public init(
        initial: State,
        actionScheduler: any ImmediateSchedulerType = MainScheduler.instance,
        eventScheduler: any ImmediateSchedulerType = MainScheduler.instance
    ) {
        self.actionScheduler = actionScheduler
        self.eventScheduler = eventScheduler
        self.stateRelay = BehaviorRelay(value: initial)
        
        super.init()
        
        #if DEBUG
        bindLogging()
        #endif
    }
    
    public func perform(_ event: Event) {
        eventRelay.accept(event)
    }
    
    public func execute(_ action: Action) {
        actionRelay.accept(action)
    }
    
    public func reduce<E>(_ handler: @escaping (E) -> State?) {
        eventRelay
            .compactMap { $0 as? E }
            .observe(on: eventScheduler)
            .compactMap(handler)
            .bind(to: stateRelay)
            .disposed(by: bag)
    }
    
    public func reduceRun<E>(_ handler: @escaping (E) -> Void) {
        eventRelay
            .compactMap { $0 as? E }
            .observe(on: eventScheduler)
            .compactMap(handler)
            .subscribe(onNext: { _ in })
            .disposed(by: bag)
    }
    
    public func reduceS<E>(_ handler: @escaping (E, State) -> State?) {
        eventRelay
            .compactMap { $0 as? E }
            .observe(on: eventScheduler)
            .withLatestFrom(stateRelay, resultSelector: { ($0, $1) })
            .compactMap(handler)
            .bind(to: stateRelay)
            .disposed(by: bag)
    }
    
    public func reduceRunS<E>(_ handler: @escaping (E, State) -> Void) {
        eventRelay
            .compactMap { $0 as? E }
            .observe(on: eventScheduler)
            .withLatestFrom(stateRelay, resultSelector: { ($0, $1) })
            .compactMap(handler)
            .subscribe(onNext: { _ in })
            .disposed(by: bag)
    }
    
    public func on<A>(_ handler: @escaping (A) -> Event?) {
        actionRelay
            .compactMap { $0 as? A }
            .observe(on: actionScheduler)
            .compactMap(handler)
            .bind(to: eventRelay)
            .disposed(by: bag)
    }
    
    public func onRun<A>(_ handler: @escaping (A) -> Void) {
        actionRelay
            .compactMap { $0 as? A }
            .observe(on: actionScheduler)
            .compactMap(handler)
            .subscribe(onNext: { _ in })
            .disposed(by: bag)
    }
    
    public func on<A>(sequential handler: @escaping (A) -> Observable<Event>) {
        actionRelay
            .compactMap { $0 as? A }
            .observe(on: actionScheduler)
            .concatMap(handler)
            #if DEBUG
            .do(onError: { assertionFailure("Errors are not allowed \($0.localizedDescription)") })
            #endif
            .observe(on: actionScheduler)
            .bind(to: eventRelay)
            .disposed(by: bag)
    }
    
    public func on<A>(droppable handler: @escaping (A) -> Observable<Event>) {
        actionRelay
            .compactMap { $0 as? A }
            .observe(on: actionScheduler)
            .flatMapFirst(handler)
            #if DEBUG
            .do(onError: { assertionFailure("Errors are not allowed \($0.localizedDescription)") })
            #endif
            .observe(on: actionScheduler)
            .bind(to: eventRelay)
            .disposed(by: bag)
    }
    
    public func on<A>(restartable handler: @escaping (A) -> Observable<Event>) {
        actionRelay
            .compactMap { $0 as? A }
            .observe(on: actionScheduler)
            .flatMapLatest(handler)
            #if DEBUG
            .do(onError: { assertionFailure("Errors are not allowed \($0.localizedDescription)") })
            #endif
            .observe(on: actionScheduler)
            .bind(to: eventRelay)
            .disposed(by: bag)
    }
    
    public func on<A>(concurrent handler: @escaping (A) -> Observable<Event>) {
        actionRelay
            .compactMap { $0 as? A }
            .observe(on: actionScheduler)
            .flatMap(handler)
            #if DEBUG
            .do(onError: { assertionFailure("Errors are not allowed \($0.localizedDescription)") })
            #endif
            .observe(on: actionScheduler)
            .bind(to: eventRelay)
            .disposed(by: bag)
    }
    
    public func onS<A>(_ handler: @escaping (A, State) -> Event?) {
        actionRelay
            .compactMap { $0 as? A }
            .observe(on: actionScheduler)
            .withLatestFrom(stateRelay, resultSelector: { ($0, $1) })
            .compactMap(handler)
            .observe(on: actionScheduler)
            .bind(to: eventRelay)
            .disposed(by: bag)
    }
    
    public func onRunS<A>(_ handler: @escaping (A, State) -> Void) {
        actionRelay
            .compactMap { $0 as? A }
            .observe(on: actionScheduler)
            .withLatestFrom(stateRelay, resultSelector: { ($0, $1) })
            .compactMap(handler)
            .subscribe(onNext: { _ in })
            .disposed(by: bag)
    }
    
    public func onS<A>(sequential handler: @escaping (A, State) -> Observable<Event>) {
        actionRelay
            .compactMap { $0 as? A }
            .observe(on: actionScheduler)
            .withLatestFrom(stateRelay, resultSelector: { ($0, $1) })
            .concatMap(handler)
            #if DEBUG
            .do(onError: { assertionFailure("Errors are not allowed \($0.localizedDescription)") })
            #endif
            .observe(on: actionScheduler)
            .bind(to: eventRelay)
            .disposed(by: bag)
    }
    
    public func onS<A>(droppable handler: @escaping (A, State) -> Observable<Event>) {
        actionRelay
            .compactMap { $0 as? A }
            .observe(on: actionScheduler)
            .withLatestFrom(stateRelay, resultSelector: { ($0, $1) })
            .flatMapFirst(handler)
            #if DEBUG
            .do(onError: { assertionFailure("Errors are not allowed \($0.localizedDescription)") })
            #endif
            .observe(on: actionScheduler)
            .bind(to: eventRelay)
            .disposed(by: bag)
    }
    
    public func onS<A>(restartable handler: @escaping (A, State) -> Observable<Event>) {
        actionRelay
            .compactMap { $0 as? A }
            .observe(on: actionScheduler)
            .withLatestFrom(stateRelay, resultSelector: { ($0, $1) })
            .flatMapLatest(handler)
            #if DEBUG
            .do(onError: { assertionFailure("Errors are not allowed \($0.localizedDescription)") })
            #endif
            .observe(on: actionScheduler)
            .bind(to: eventRelay)
            .disposed(by: bag)
    }
    
    public func onS<A>(concurrent handler: @escaping (A, State) -> Observable<Event>) {
        actionRelay
            .compactMap { $0 as? A }
            .observe(on: actionScheduler)
            .withLatestFrom(stateRelay, resultSelector: { ($0, $1) })
            .flatMap(handler)
            #if DEBUG
            .do(onError: { assertionFailure("Errors are not allowed \($0.localizedDescription)") })
            #endif
            .observe(on: actionScheduler)
            .bind(to: eventRelay)
            .disposed(by: bag)
    }
    
    #if DEBUG
    private func bindLogging() {
        eventRelay
            .subscribe(onNext: { [weak self] in self?.log(event: $0) })
            .disposed(by: bag)
        actionRelay
            .subscribe(onNext: { [weak self] in self?.log(action: $0) })
            .disposed(by: bag)
        stateObs
            .scan((state, state), accumulator: { ($0.1, $1) })
            .skip(1)
            .do(onSubscribe: { [weak self] in
                guard let self else { return }

                self.log(state: ("Initial state", self.state))
            })
            .subscribe(onNext: { [weak self] in self?.log(state: $0) })
            .disposed(by: bag)
    }

    // TODO: - OS
    func log(state: (Any, Any)) {
        debugPrint("""
            [StateModel 🟢 update state] \
            from: [\(String(describing: state.0).prefix(200))] \
            to: [\(String(describing: state.1).prefix(200))]
            """
        )
    }
    
    func log(event: Any) {
        debugPrint("""
            [StateModel 🟡 incoming event] \
            [\(String(describing: event).prefix(200))]
            """
        )
    }
    
    private func log(action: Any) {
        debugPrint("""
            [StateModel 🟠 incoming action] \
            [\(String(describing: action).prefix(200))]
            """
        )
    }
    
    deinit {
        debugPrint("\(#function) \(String(describing: self))")
    }
    #endif
}
