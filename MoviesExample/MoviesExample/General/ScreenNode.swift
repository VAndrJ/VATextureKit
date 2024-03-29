//
//  DisplayNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx
import RxKeyboard

class ScreenNode<ViewModel: EventViewModel>: VASafeAreaDisplayNode, ControllerNode, Responder, MainActorIsolated {
    let bag = DisposeBag()
    let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    override func didLoad() {
        super.didLoad()

        configure()
        bind()
    }

    func viewDidLoad(in controller: UIViewController) {
        viewModel.controller = controller
    }

    func viewDidAppear(in controller: UIViewController, animated: Bool) {}

    func viewWillAppear(in controller: UIViewController, animated: Bool) {}

    func viewWillDisappear(in controller: UIViewController, animated: Bool) {}

    func viewDidDisappear(in controller: UIViewController, animated: Bool) {}

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
                    .map { max($0, $1) }
            )
            .map { keyboardHeight, safeAreaBottom, tabBarHeght in
                let possibleBottomInset = keyboardHeight - max(safeAreaBottom, tabBarHeght)
                
                return (max(possibleBottomInset, initialBottomInset), max(possibleBottomInset, initialIndicatorBottomInset))
            }
            .subscribe(onNext: scrollView ?> {
                $0.contentInset.bottom = $1
                $0.verticalScrollIndicatorInsets.bottom = $2
            })
            .disposed(by: bag)
    }

    func bind() {}

    func configure() {}

    // MARK: - Responder

    var nextEventResponder: Responder? {
        get { viewModel }
        set { viewModel.nextEventResponder = newValue }
    }

    func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)

        return await nextEventResponder?.handle(event: event) ?? false
    }
}
