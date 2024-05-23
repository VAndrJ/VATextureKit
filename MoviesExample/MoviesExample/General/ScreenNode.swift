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
        // `The compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions` since Xcode 15.4
        let keyboardObs: Observable<CGFloat> = RxKeyboard.instance.visibleHeight
            .asObservable()
            .distinctUntilChanged()
        let safeAreaBottomObs: Observable<CGFloat> = rx.observe(UIEdgeInsets.self, #keyPath(ASDisplayNode.safeAreaInsets))
            .compactMap(\.?.bottom)
            .distinctUntilChanged()
        let tabBarHeightObs: Observable<CGFloat> = Observable
            .combineLatest(
                tabBarController?.tabBar.rx.observe(CGRect.self, #keyPath(UITabBar.bounds))
                    .compactMap(\.?.height)
                    .distinctUntilChanged() ?? .just(0),
                tabBarController?.view.rx.observe(UIEdgeInsets.self, #keyPath(UIView.safeAreaInsets))
                    .compactMap(\.?.bottom)
                    .distinctUntilChanged() ?? .just(0)
            )
            .map { max($0, $1) }
        Observable
            .combineLatest(
                keyboardObs,
                safeAreaBottomObs,
                tabBarHeightObs
            )
            .map { (keyboardHeight: CGFloat, safeAreaBottom: CGFloat, tabBarHeght: CGFloat) -> (CGFloat, CGFloat) in
                let possibleBottomInset = keyboardHeight - max(safeAreaBottom, tabBarHeght)
                
                return (max(possibleBottomInset, initialBottomInset), max(possibleBottomInset, initialIndicatorBottomInset))
            }
            .subscribe(onNext: scrollView ?> {
                $0.contentInset.bottom = $1.0
                $0.verticalScrollIndicatorInsets.bottom = $1.1
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
