//
//  VATableListNode.swift
//  VATextureKitRx
//
//  Created by Volodymyr Andriienko on 27.03.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
public import RxSwift
public import RxCocoa
public import VATextureKit
public import Differentiator
#else
import AsyncDisplayKit
import RxSwift
import RxCocoa
import VATextureKit
import Differentiator
#endif

open class VATableListNode<S: AnimatableSectionModelType>: VASimpleTableNode {
    public struct SeparatorConfiguration {
        let color: UIColor?
        let style: UITableViewCell.SeparatorStyle
        let effect: UIVisualEffect?
        let insetReference: UITableView.SeparatorInsetReference?

        public init(
            color: UIColor? = nil,
            style: UITableViewCell.SeparatorStyle = .singleLine,
            effect: UIVisualEffect? = nil,
            insetReference: UITableView.SeparatorInsetReference? = nil
        ) {
            self.color = color
            self.style = style
            self.effect = effect
            self.insetReference = insetReference
        }
    }

    public struct Configuration {
        let keyboardDismissMode: UIScrollView.KeyboardDismissMode?
        let separatorConfiguration: SeparatorConfiguration
        let animationConfiguration: AnimationConfiguration
        let style: UITableView.Style
        let shouldScrollToTopOnDataChange: Bool
        let shouldDeselect: (deselectOnSelect: Bool, animated: Bool)

        public init(
            keyboardDismissMode: UIScrollView.KeyboardDismissMode? = nil,
            separatorConfiguration: SeparatorConfiguration = .init(),
            animationConfiguration: AnimationConfiguration = .init(),
            style: UITableView.Style = .plain,
            shouldScrollToTopOnDataChange: Bool = false,
            shouldDeselect: (deselectOnSelect: Bool, animated: Bool) = (true, true)
        ) {
            self.keyboardDismissMode = keyboardDismissMode
            self.separatorConfiguration = separatorConfiguration
            self.animationConfiguration = animationConfiguration
            self.style = style
            self.shouldScrollToTopOnDataChange = shouldScrollToTopOnDataChange
            self.shouldDeselect = shouldDeselect
        }
    }

    public struct ElementDTO {
        let configuration: Configuration
        let listDataObs: Observable<[S.Item]>
        let onSelect: ((IndexPath) -> Void)?
        let cellGetter: (S.Item) -> ASCellNode
        let sectionHeaderGetter: ((S) -> ASDisplayNode)?
        let sectionFooterGetter: ((S) -> ASDisplayNode)?
        let shouldBatchFetch: (() -> Bool)?
        let loadMore: () -> Void
        
        public init(
            configuration: Configuration = .init(),
            listDataObs: Observable<[S.Item]>,
            onSelect: ((IndexPath) -> Void)? = nil,
            cellGetter: @escaping (S.Item) -> ASCellNode,
            sectionHeaderGetter: ((S) -> ASDisplayNode)? = nil,
            sectionFooterGetter: ((S) -> ASDisplayNode)? = nil,
            shouldBatchFetch: (() -> Bool)? = nil,
            loadMore: @escaping () -> Void = {}
        ) {
            self.configuration = configuration
            self.listDataObs = listDataObs
            self.onSelect = onSelect
            self.cellGetter = cellGetter
            self.sectionHeaderGetter = sectionHeaderGetter
            self.sectionFooterGetter = sectionFooterGetter
            self.shouldBatchFetch = shouldBatchFetch
            self.loadMore = loadMore
        }
    }

    public struct AnimatableSectionDTO<Model: IdentifiableType, Item> where Item == S.Item {
        let configuration: Configuration
        let listDataObs: Observable<[AnimatableSectionModel<Model, Item>]>
        let onSelect: ((IndexPath) -> Void)?
        let cellGetter: (Item) -> ASCellNode
        let sectionHeaderGetter: ((Model) -> ASDisplayNode)?
        let sectionFooterGetter: ((Model) -> ASDisplayNode)?
        let shouldBatchFetch: (() -> Bool)?
        let loadMore: () -> Void

        public init(
            configuration: Configuration = .init(),
            listDataObs: Observable<[AnimatableSectionModel<Model, Item>]>,
            onSelect: ((IndexPath) -> Void)? = nil,
            cellGetter: @escaping (Item) -> ASCellNode,
            sectionHeaderGetter: ((Model) -> ASDisplayNode)? = nil,
            sectionFooterGetter: ((Model) -> ASDisplayNode)? = nil,
            shouldBatchFetch: (() -> Bool)? = nil,
            loadMore: @escaping () -> Void = {}
        ) {
            self.configuration = configuration
            self.listDataObs = listDataObs
            self.onSelect = onSelect
            self.cellGetter = cellGetter
            self.sectionHeaderGetter = sectionHeaderGetter
            self.sectionFooterGetter = sectionFooterGetter
            self.shouldBatchFetch = shouldBatchFetch
            self.loadMore = loadMore
        }
    }
    
    public struct Context {
        let configuration: Configuration
        let listDataObs: Observable<[S]>
        let onSelect: ((IndexPath) -> Void)?
        let cellGetter: (S.Item) -> ASCellNode
        let sectionHeaderGetter: ((S) -> ASDisplayNode)?
        let sectionFooterGetter: ((S) -> ASDisplayNode)?
        let shouldBatchFetch: (() -> Bool)?
        let loadMore: () -> Void
        
        public init(
            configuration: Configuration = .init(),
            listDataObs: Observable<[S]>,
            onSelect: ((IndexPath) -> Void)? = nil,
            cellGetter: @escaping (S.Item) -> ASCellNode,
            sectionHeaderGetter: ((S) -> ASDisplayNode)? = nil,
            sectionFooterGetter: ((S) -> ASDisplayNode)? = nil,
            shouldBatchFetch: (() -> Bool)? = nil,
            loadMore: @escaping () -> Void = {}
        ) {
            self.configuration = configuration
            self.listDataObs = listDataObs
            self.onSelect = onSelect
            self.cellGetter = cellGetter
            self.sectionHeaderGetter = sectionHeaderGetter
            self.sectionFooterGetter = sectionFooterGetter
            self.shouldBatchFetch = shouldBatchFetch
            self.loadMore = loadMore
        }
    }
    
    public struct RefreshDTO {
        let refreshControlView: @MainActor () -> UIRefreshControl
        let isDelayed: Bool
        let reloadData: (() -> Void)?
        let isLoadingObs: Observable<Bool>

        public init(
            refreshControlView: @escaping @MainActor () -> UIRefreshControl = { UIRefreshControl() },
            isDelayed: Bool = true,
            reloadData: @escaping () -> Void,
            isLoadingObs: Observable<Bool>
        ) {
            self.refreshControlView = refreshControlView
            self.isDelayed = isDelayed
            self.reloadData = reloadData
            self.isLoadingObs = isLoadingObs
        }

        public init() {
            self.refreshControlView = { @MainActor in UIRefreshControl() }
            self.isDelayed = false
            self.reloadData = nil
            self.isLoadingObs = .empty()
        }
    }

    @MainActor
    class DelegateObject: NSObject, ASTableDelegate {
        let context: Context
        weak var source: RxASTableSectionedAnimatedDataSource<S>?
        var toggleRefreshIfNeeded: () -> Void

        init(
            context: Context,
            source: RxASTableSectionedAnimatedDataSource<S>?,
            toggleRefreshIfNeeded: @escaping () -> Void
        ) {
            self.context = context
            self.source = source
            self.toggleRefreshIfNeeded = toggleRefreshIfNeeded
        }

        // MARK: - ASTableDelegate

        public func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
            context.shouldBatchFetch?() ?? false
        }

        public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if let getter = context.sectionHeaderGetter, let section = source?[safe: section] {
                return VANodeWrapperView(contentNode: getter(section))
            } else {
                return nil
            }
        }

        public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            if let getter = context.sectionFooterGetter, let section = source?[safe: section] {
                return VANodeWrapperView(contentNode: getter(section))
            } else {
                return nil
            }
        }

        public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                toggleRefreshIfNeeded()
            }
        }

        public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            toggleRefreshIfNeeded()
        }
    }

    public let context: Context
    public let refreshData: RefreshDTO
    public private(set) var batchContext: ASBatchContext?
    
    private let bag = DisposeBag()
    private weak var source: RxASTableSectionedAnimatedDataSource<S>?
    @MainActor
    private lazy var refreshControlView = refreshData.refreshControlView()
    @MainActor
    private lazy var delegateObject = DelegateObject(
        context: context,
        source: source,
        toggleRefreshIfNeeded: { [weak self] in
            self?.toggleRefreshIfNeeded()
        }
    )
    private var isRefreshing = false
    
    public convenience init<T>(
        data: ElementDTO,
        refreshData: RefreshDTO = .init()
    ) where S == AnimatableSectionModel<String, T> {
        self.init(
            context: .init(
                configuration: data.configuration,
                listDataObs: data.listDataObs.map { [AnimatableSectionModel(model: "test", items: $0)] },
                onSelect: data.onSelect,
                cellGetter: data.cellGetter,
                sectionHeaderGetter: data.sectionHeaderGetter,
                sectionFooterGetter: data.sectionFooterGetter,
                shouldBatchFetch: data.shouldBatchFetch,
                loadMore: data.loadMore
            ),
            refreshData: refreshData
        )
    }

    public convenience init<Model, Item>(
        data: AnimatableSectionDTO<Model, Item>,
        refreshData: RefreshDTO = .init()
    ) where Item == S.Item, S == AnimatableSectionModel<Model, Item> {
        self.init(
            context: .init(
                configuration: data.configuration,
                listDataObs: data.listDataObs,
                onSelect: data.onSelect,
                cellGetter: data.cellGetter,
                sectionHeaderGetter: data.sectionHeaderGetter.flatMap { getter in { getter($0.model) } },
                sectionFooterGetter: data.sectionFooterGetter.flatMap { getter in { getter($0.model) } },
                shouldBatchFetch: data.shouldBatchFetch,
                loadMore: data.loadMore
            ),
            refreshData: refreshData
        )
    }
    
    public init(context: Context, refreshData: RefreshDTO = .init()) {
        self.refreshData = refreshData
        self.context = context
        
        super.init(style: context.configuration.style)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        bind()
    }

    @MainActor
    open func configureRefresh() {
        if refreshData.reloadData != nil {
            view.insertSubview(refreshControlView, at: 0)
            refreshControlView.rx.controlEvent(.valueChanged)
                .do(afterNext: { [refreshData] _ in
                    if !refreshData.isDelayed {
                        refreshData.reloadData?()
                    }
                })
                .map { _ in true }
                .bind(to: refreshControlView.rx.isRefreshing)
                .disposed(by: bag)
            refreshData.isLoadingObs
                .bind(to: refreshControlView.rx.isRefreshing, rx.isRefreshing)
                .disposed(by: bag)
        }
    }

    @MainActor
    private func bind() {
        let dataSource = RxASTableSectionedAnimatedDataSource<S>(
            animationConfiguration: context.configuration.animationConfiguration,
            configureCellBlock: { [context] _, _, _, item in { context.cellGetter(item) } }
        )
        self.source = dataSource
        context.listDataObs
            .do(onNext: { [weak self, shouldScrollToTopOnDataChange = context.configuration.shouldScrollToTopOnDataChange] _ in
                self?.batchContext?.completeBatchFetching(true)
                self?.batchContext = nil
                if shouldScrollToTopOnDataChange {
                    self?.view.scrollRectToVisible(.init(width: 1, height: 1), animated: true)
                }
            })
            .bind(to: rx.items(dataSource: dataSource))
            .disposed(by: bag)
        rx.setDelegate(delegateObject)
            .disposed(by: bag)
        if context.shouldBatchFetch != nil {
            rx.willBeginBatchFetch
                .do(onNext: { [weak self] in self?.batchContext = $0 })
                .map { _ in }
                .subscribe(onNext: context.loadMore)
                .disposed(by: bag)
        }
        if context.configuration.shouldDeselect.deselectOnSelect {
            rx.itemSelected
                .subscribe(onNext: { [weak self, animated = context.configuration.shouldDeselect.animated] in
                    self?.deselectRow(at: $0, animated: animated)
                })
                .disposed(by: bag)
        }
        if let onSelect = context.onSelect {
            rx.itemSelected
                .subscribe(onNext: onSelect)
                .disposed(by: bag)
        }
    }

    @MainActor
    private func configure() {
        if context.sectionHeaderGetter != nil {
            view.sectionHeaderHeight = UITableView.automaticDimension
            view.estimatedSectionHeaderHeight = .leastNormalMagnitude
            if #available(iOS 15.0, *) {
                view.sectionHeaderTopPadding = .leastNormalMagnitude
            }
        }
        if context.sectionFooterGetter != nil {
            view.sectionFooterHeight = UITableView.automaticDimension
            view.estimatedSectionFooterHeight = .leastNormalMagnitude
        }
        context.configuration.keyboardDismissMode.flatMap { view.keyboardDismissMode = $0 }
        context.configuration.separatorConfiguration.color.flatMap { view.separatorColor = $0 }
        view.separatorStyle = context.configuration.separatorConfiguration.style
        context.configuration.separatorConfiguration.effect.flatMap { view.separatorEffect = $0 }
        context.configuration.separatorConfiguration.insetReference.flatMap { view.separatorInsetReference = $0 }
        configureRefresh()
    }

    @MainActor
    private func toggleRefreshIfNeeded() {
        if let reloadData = refreshData.reloadData, refreshData.isDelayed && refreshControlView.isRefreshing && !isRefreshing {
            reloadData()
        }
    }
}
