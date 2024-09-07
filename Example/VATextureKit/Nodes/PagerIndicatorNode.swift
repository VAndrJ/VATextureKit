//
//  PagerIndicatorNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 24.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx
import Differentiator
import RxSwift
import RxCocoa

final class PagerIndicatorNode<Item: Equatable & IdentifiableType>: VASizedViewWrapperNode<UIPageControl>, @unchecked Sendable {
    private var bag = DisposeBag()
    private weak var pagerNode: VAPagerNode<Item>? {
        didSet {
            ensureOnMainActor {
                bag = DisposeBag()
                bind()
            }
        }
    }

    convenience init(pagerNode: @MainActor @escaping () -> VAPagerNode<Item>) {
        self.init(childGetter: { UIPageControl() }, sizing: .viewSize)

        ensureOnMainActor {
            self.pagerNode = pagerNode()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        child.addTarget(
            self,
            action: #selector(onChange(_:)),
            for: .valueChanged
        )
        bind()
    }

    override func configureTheme(_ theme: VATheme) {
        child.currentPageIndicatorTintColor = theme.label
        child.pageIndicatorTintColor = theme.systemOrange
    }

    @MainActor
    private func bind() {
        pagerNode?.indexObs
            .map { Int($0 + 0.5) }
            .debounce(.milliseconds(100), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind(to: child.rx.currentPage)
            .disposed(by: bag)
        pagerNode?.itemsCountObs
            .distinctUntilChanged()
            .do(afterNext: self ?>> { $0.setNeedsLayout })
            .bind(to: child.rx.numberOfPages)
            .disposed(by: bag)
    }

    @MainActor
    @objc private func onChange(_ sender: UIPageControl) {
        pagerNode?.scroll(to: sender.currentPage)
    }
}
