//
//  SearchBarNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKitRx

final class SearchBarNode: VASizedViewWrapperNode<UISearchBar> {
    var textObs: Observable<String?> { child.rx.text.asObservable() }

    private let bag = DisposeBag()

    convenience init(beginSearchObs: Observable<Void>? = nil) {
        self.init(
            childGetter: { MainActorEscaped { UISearchBar().apply { $0.searchBarStyle = .minimal } }.value },
            sizing: .viewHeight
        )

        bind(beginSearchObs: beginSearchObs)
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

    private func bind(beginSearchObs: Observable<Void>?) {
        beginSearchObs?
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [child] in
                Task { @MainActor in
                    child.becomeFirstResponder()
                }
            })
            .disposed(by: bag)
    }
}
