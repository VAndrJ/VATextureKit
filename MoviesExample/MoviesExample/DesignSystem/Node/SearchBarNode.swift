//
//  SearchBarNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKitRx
import RxSwift
import RxCocoa

final class SearchBarNode: VASizedViewWrapperNode<UISearchBar>, @unchecked Sendable {
    @MainActor var textObs: Observable<String?> { child.rx.text.asObservable() }

    private let bag = DisposeBag()
    private var beginSearchObs: Observable<Void>?

    convenience init(beginSearchObs: Observable<Void>? = nil) {
        self.init(
            childGetter: { UISearchBar().apply { $0.searchBarStyle = .minimal } },
            sizing: .viewHeight
        )

        self.beginSearchObs = beginSearchObs
    }

    override func isFirstResponder() -> Bool {
        MainActor.assumeIsolated {
            child.isFirstResponder
        }
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        MainActor.assumeIsolated {
            child.becomeFirstResponder()
        }
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        MainActor.assumeIsolated {
            child.resignFirstResponder()
        }
    }

    override func configureTheme(_ theme: VATheme) {
        child.tintColor = theme.secondary
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
