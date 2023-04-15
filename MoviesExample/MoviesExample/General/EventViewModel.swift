//
//  EventViewModel.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import UIKit
import VATextureKit

struct BecomeVisibleEvent: Event {}

struct LoadDataEvent: Event {}

struct DidSelectEvent: Event {
    let indexPath: IndexPath
}

protocol Event {}

@MainActor
class EventViewModel: ViewModel {
    let bag = DisposeBag()
    let eventRelay = PublishRelay<Event>()
    var isLoadingObs: Observable<Bool> { isLoadingRelay.asObservable() }
    var isNotLoading: Bool { !isLoadingRelay.value }
    weak var controller: UIViewController?
    var isLoadingRelay = BehaviorRelay(value: false)

    private let scheduler: ImmediateSchedulerType

    init(scheduler: ImmediateSchedulerType = MainScheduler.asyncInstance) {
        self.scheduler = scheduler

        super.init()

        bind()
    }

    func run(_ event: Event) {
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
            .subscribe(onNext: { [weak self] in
                self?.run($0)
            })
            .disposed(by: bag)
    }

#if DEBUG || targetEnvironment(simulator)
    private func bindLogging() {
        eventRelay
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.log(event: $0, file: String(describing: self))
            })
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
