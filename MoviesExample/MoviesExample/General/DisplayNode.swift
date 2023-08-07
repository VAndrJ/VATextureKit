//
//  DisplayNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx
import RxKeyboard

class DisplayNode<ViewModel: EventViewModel>: VASafeAreaDisplayNode, Responder, ControllerNode {
    let bag = DisposeBag()
    var nextEventResponder: Responder? {
        get { viewModel }
        set {} // swiftlint:disable:this unused_setter_value
    }
    let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    func viewDidLoad(in controller: UIViewController) {
        viewModel.controller = controller
    }

    func viewDidAppear(in controller: UIViewController, animated: Bool) {}

    func viewWillAppear(in controller: UIViewController, animated: Bool) {}

    func viewWillDisappear(in controller: UIViewController, animated: Bool) {}

    func viewDidDisappear(in controller: UIViewController, animated: Bool) {}

    func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)
        return await nextEventResponder?.handle(event: event) ?? false
    }

    func bindKeyboardInset(scrollView: UIScrollView, tabBarController: UITabBarController? = nil) {
        let initialBottomInset = scrollView.contentInset.bottom
        let initialIndicatorBottomInset = scrollView.verticalScrollIndicatorInsets.bottom
        Observable
            .combineLatest(
                RxKeyboard.instance.visibleHeight
                    .asObservable()
                    .distinctUntilChanged(),
                rx.observe(UIEdgeInsets.self, #keyPath(ASDisplayNode.safeAreaInsets))
                    .compactMap(\.?.bottom)
                    .distinctUntilChanged(),
                Observable
                    .combineLatest(
                        tabBarController?.tabBar.rx.observe(CGRect.self, #keyPath(UITabBar.bounds))
                            .compactMap(\.?.height)
                            .distinctUntilChanged() ?? .just(0),
                        tabBarController?.view.rx.observe(UIEdgeInsets.self, #keyPath(UIView.safeAreaInsets))
                            .compactMap(\.?.bottom)
                            .distinctUntilChanged() ?? .just(0)
                    )
                    .map { $0 + $1 }
            )
            .map { keyboardHeight, safeAreaBottom, tabBarHeght in
                let possibleBottomInset = keyboardHeight - max(safeAreaBottom, tabBarHeght)
                return (max(possibleBottomInset, initialBottomInset), max(possibleBottomInset, initialIndicatorBottomInset))
            }
            .subscribe(onNext: { bottomInset, indicatorBottomInset in
                scrollView.contentInset.bottom = bottomInset
                scrollView.verticalScrollIndicatorInsets.bottom = indicatorBottomInset
            })
            .disposed(by: bag)
    }
}
