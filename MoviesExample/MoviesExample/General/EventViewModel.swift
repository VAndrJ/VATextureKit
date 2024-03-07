//
//  EventViewModel.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

struct BecomeVisibleEvent: Event {}

struct LoadDataEvent: Event {}

struct DidSelectEvent: Event {
    let indexPath: IndexPath
}

protocol Event: Sendable {}

class EventViewModel: ViewModel {
    let bag = DisposeBag()
    let eventRelay = PublishRelay<Event>()
    var isLoadingObs: Observable<Bool> { isLoadingRelay.asObservable() }
    var isNotLoading: Bool { !isLoadingRelay.value }
    weak var controller: UIViewController?
    var isLoadingRelay = BehaviorRelay(value: false)

    let scheduler: SchedulerType

    init(scheduler: SchedulerType = MainScheduler.asyncInstance) {
        self.scheduler = scheduler

        super.init()

        bind()
    }

    @MainActor
    func run(_ event: Event) async {
        #if DEBUG || targetEnvironment(simulator)
        debugPrint("⚠️ [Event not handled] \(event)")
        #endif
    }

    func perform(_ event: Event) {
        eventRelay.accept(event)
    }

    private func bind() {
        bindEvents()
        #if DEBUG || targetEnvironment(simulator)
        bindLogging()
        #endif
    }

    private func bindEvents() {
        eventRelay
            .observe(on: scheduler)
            .subscribe(onNext: { [weak self] event in
                Task { @MainActor [weak self] in
                    await self?.run(event)
                }
            })
            .disposed(by: bag)
    }

    #if DEBUG || targetEnvironment(simulator)
    private func bindLogging() {
        eventRelay
            .subscribe(onNext: self ?> { $0.log(event: $1, file: String(describing: $0)) })
            .disposed(by: bag)
    }

    func log(event: Any, file: String = #file) {
        let eventString = String(describing: event).prefix(500)
        let fileName = (String(describing: file) as NSString).lastPathComponent
        let outputString = "[Incoming event] [file: \(fileName)] \(eventString)"
        debugPrint(outputString)
    }

    deinit {
        debugPrint("\(#function) \(String(describing: self))")
    }
    #endif
}
