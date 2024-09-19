//
//  DisplayNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx
import RxKeyboard
import RxSwift
import RxCocoa

class ScreenNode<ViewModel: EventViewModel>: VASafeAreaDisplayNode, ControllerNode, Responder, @unchecked Sendable {
    let bag = DisposeBag()
    let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        bind()
    }

    @MainActor
    func viewDidLoad(in controller: UIViewController) {
        viewModel.controller = controller
    }

    @MainActor
    func viewDidAppear(in controller: UIViewController, animated: Bool) {}

    @MainActor
    func viewWillAppear(in controller: UIViewController, animated: Bool) {}

    @MainActor
    func viewWillDisappear(in controller: UIViewController, animated: Bool) {}

    @MainActor
    func viewDidDisappear(in controller: UIViewController, animated: Bool) {}

    @MainActor
    func bindKeyboardInset(scrollView: UIScrollView, tabBarController: UITabBarController? = nil) {
        let initialBottomInset = scrollView.contentInset.bottom
        let initialIndicatorBottomInset = scrollView.verticalScrollIndicatorInsets.bottom
        // `The compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions` since Xcode 15.4
        let keyboardObs: Observable<CGFloat> = RxKeyboard.instance.visibleHeight
            .asObservable()
            .distinctUntilChanged()
        let safeAreaBottomObs: Observable<CGFloat> = rx.observe(UIEdgeInsets.self, #keyPath(ASDisplayNode.safeAreaInsets))
            .compactMap { $0?.bottom }
            .distinctUntilChanged()
        let tabBarHeightObs: Observable<CGFloat> = Observable
            .combineLatest(
                tabBarController?.tabBar.rx.observe(CGRect.self, #keyPath(UITabBar.bounds))
                    .compactMap { $0?.height }
                    .distinctUntilChanged() ?? .just(0),
                tabBarController?.view.rx.observe(UIEdgeInsets.self, #keyPath(UIView.safeAreaInsets))
                    .compactMap { $0?.bottom }
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
            .subscribeMain(onNext: { [weak scrollView] in
                scrollView?.contentInset.bottom = $0.0
                scrollView?.verticalScrollIndicatorInsets.bottom = $0.1
            })
            .disposed(by: bag)
    }

    @MainActor
    func bind() {}

    @MainActor
    func configure() {}

    // MARK: - Responder

    var nextEventResponder: (any Responder)? {
        get { viewModel }
        set { viewModel.nextEventResponder = newValue }
    }

    func handle(event: any ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)

        return await nextEventResponder?.handle(event: event) ?? false
    }
}
