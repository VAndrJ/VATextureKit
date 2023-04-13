//
//  VAKeyboardNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxKeyboard
import Swiftional

public final class VAKeyboardSpacingNode: ASDisplayNode {
    struct DTO: Applyable {
        weak var parent: ASDisplayNode?
        var isOpenedKeyboardWithoutSafeArea = true
        var isClosedKeyboardWithoutMinSafeArea = true
        var deltaMin: CGFloat = 0
        var deltaMax: CGFloat = 0
        var backgroundColor: UIColor = .clear
    }

    private let bag = DisposeBag()
    private let safeAreaBottomRelay = BehaviorRelay<CGFloat>(value: 0)
    private let tabBarHeightRelay = BehaviorRelay<CGFloat>(value: 0)
    private var data: DTO
    private var safeAreaDisposable: Disposable?

    init(data: DTO) {
        self.data = data

        super.init()

        automaticallyRelayoutOnSafeAreaChanges = data.parent == nil
    }

    public override func didLoad() {
        super.didLoad()

        backgroundColor = .clear
        bind()
        updateSafeAreaBottom()
    }

    public func bindTabBar(controller: UITabBarController) {
        controller.tabBar.rx.observe(CGRect.self, #keyPath(UITabBar.bounds))
            .compactMap(\.?.height)
            .bind(to: tabBarHeightRelay)
            .disposed(by: bag)
    }

    public override func layout() {
        super.layout()

        updateSafeAreaBottom()
    }

    private func updateSafeAreaBottom() {
        if safeAreaDisposable == nil {
            safeAreaBottomRelay.accept(safeAreaInsets.bottom)
        }
    }

    private func update(keyboardHeight: CGFloat, safeAreaBottomHeight: CGFloat, tabBarHeight: CGFloat) {
        style.height = ASDimension(
            unit: .points,
            value: max(
                data.deltaMin + (data.isClosedKeyboardWithoutMinSafeArea ? 0 : safeAreaBottomHeight),
                data.deltaMax + keyboardHeight - (data.isOpenedKeyboardWithoutSafeArea ? safeAreaBottomHeight : 0) - tabBarHeight
            )
        )
        setNeedsLayout()
    }

    private func bind() {
        if let parent = data.parent {
            safeAreaDisposable = parent.rx.observe(UIEdgeInsets.self, #keyPath(ASDisplayNode.safeAreaInsets))
                .compactMap(\.?.bottom)
                .bind(to: safeAreaBottomRelay)
            safeAreaDisposable?.disposed(by: bag)
        }
        Observable
            .combineLatest(
                RxKeyboard.instance.visibleHeight
                    .asObservable()
                    .distinctUntilChanged(),
                safeAreaBottomRelay
                    .distinctUntilChanged(),
                tabBarHeightRelay
                    .distinctUntilChanged()
            )
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] keyboardHeight, safeAreaBottomHeight, tabBarHeight in
                self?.update(
                    keyboardHeight: keyboardHeight,
                    safeAreaBottomHeight: safeAreaBottomHeight,
                    tabBarHeight: tabBarHeight
                )
            })
            .disposed(by: bag)
    }
}
