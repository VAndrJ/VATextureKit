//
//  SearchBarNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKitRx

final class SearchBarNode: VASizedViewWrapperNode<UISearchBar> {
    @MainActor var textObs: Observable<String?> { child.rx.text.asObservable() }

    private let bag = DisposeBag()
    private var beginSearchObs: Observable<Void>?

    convenience init(beginSearchObs: Observable<Void>? = nil) {
        self.init(
            actorChildGetter: { UISearchBar().apply { $0.searchBarStyle = .minimal } },
            sizing: .viewHeight
        )

        self.beginSearchObs = beginSearchObs
    }

    @MainActor
    override func isFirstResponder() -> Bool {
        child.isFirstResponder
    }

    @MainActor
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        child.becomeFirstResponder()
    }

    @MainActor
    @discardableResult
    override func resignFirstResponder() -> Bool {
        child.resignFirstResponder()
    }

    override func configureTheme(_ theme: VATheme) {
        child.tintColor = theme.secondary
    }
    override func didLoad() {
        super.didLoad()

        bind(beginSearchObs: beginSearchObs)
    }

    @MainActor
    private func bind(beginSearchObs: Observable<Void>?) {
        beginSearchObs?
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: child ?> { $0.becomeFirstResponder() })
            .disposed(by: bag)
    }
}
