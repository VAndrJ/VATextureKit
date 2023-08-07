//
//  PagerIndicatorNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 24.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

final class PagerIndicatorNode<Item: Equatable & IdentifiableType>: VASizedViewWrapperNode<UIPageControl> {
    private let bag = DisposeBag()
    private weak var pagerNode: VAPagerNode<Item>?

    convenience init(pagerNode: VAPagerNode<Item>) {
        self.init(childGetter: { UIPageControl() }, sizing: .viewSize)

        self.pagerNode = pagerNode
        pagerNode.indexObs
            .map { Int($0 + 0.5) }
            .debounce(.milliseconds(100), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind(to: child.rx.currentPage)
            .disposed(by: bag)
        pagerNode.itemsCountObs
            .distinctUntilChanged()
            .do(afterNext: { [weak self] _ in self?.setNeedsLayout() })
            .bind(to: child.rx.numberOfPages)
            .disposed(by: bag)
    }

    override func didLoad() {
        super.didLoad()

        bind()
    }

    override func configureTheme(_ theme: VATheme) {
        child.currentPageIndicatorTintColor = theme.label
        child.pageIndicatorTintColor = theme.systemOrange
    }

    private func bind() {
        child.addTarget(
            self,
            action: #selector(onChange(_:)),
            for: .valueChanged
        )
    }

    @objc private func onChange(_ sender: UIPageControl) {
        pagerNode?.scroll(to: sender.currentPage)
    }
}
