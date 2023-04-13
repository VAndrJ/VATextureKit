//
//  VATableListNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 27.03.2023.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

open class VATableListNode<S: AnimatableSectionModelType>: ASTableNode, ASTableDelegate {
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
    
    public struct DTO {
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
        let refreshControlView: () -> UIRefreshControl
        let isDelayed: Bool
        let reloadData: (() -> Void)?
        let isLoadingObs: Observable<Bool>

        public init(
            refreshControlView: @escaping () -> UIRefreshControl = { UIRefreshControl() },
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
            self.refreshControlView = { UIRefreshControl() }
            self.isDelayed = false
            self.reloadData = nil
            self.isLoadingObs = .empty()
        }
    }
    
    public let data: DTO
    public let refreshData: RefreshDTO
    public private(set) var batchContext: ASBatchContext?
    
    private let bag = DisposeBag()
    private weak var source: RxASTableSectionedAnimatedDataSource<S>?
    private lazy var refreshControlView = refreshData.refreshControlView()
    private var isRefreshing = false
    private let delayedConfiguration: Bool
    
    public convenience init<T>(data: ElementDTO, refreshData: RefreshDTO = .init()) where S == AnimatableSectionModel<String, T> {
        self.init(
            data: DTO(
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

    public convenience init<Model, Item>(data: AnimatableSectionDTO<Model, Item>, refreshData: RefreshDTO = .init()) where Item == S.Item, S == AnimatableSectionModel<Model, Item> {
        self.init(
            data: DTO(
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
    
    public init(data: DTO, refreshData: RefreshDTO = .init()) {
        self.refreshData = refreshData
        self.data = data
        self.delayedConfiguration = !Thread.current.isMainThread
        
        super.init(style: data.configuration.style)

        if !delayedConfiguration {
            configure()
            bind()
        }
    }

    open override func didLoad() {
        super.didLoad()

        if delayedConfiguration {
            configure()
            bind()
        }
    }

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

    private func bind() {
        let dataSource = RxASTableSectionedAnimatedDataSource<S>(
            animationConfiguration: data.configuration.animationConfiguration,
            configureCellBlock: { [data] _, _, _, item in { data.cellGetter(item) } }
        )
        self.source = dataSource
        data.listDataObs
            .do(onNext: { [weak self, shouldScrollToTopOnDataChange = data.configuration.shouldScrollToTopOnDataChange] _ in
                self?.batchContext?.completeBatchFetching(true)
                if shouldScrollToTopOnDataChange {
                    self?.view.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
                }
            })
            .bind(to: rx.items(dataSource: dataSource))
            .disposed(by: bag)
        rx.setDelegate(self)
            .disposed(by: bag)
        if data.shouldBatchFetch != nil {
            rx.willBeginBatchFetch
                .do(onNext: { [weak self] in self?.batchContext = $0 })
                .map { _ in }
                .subscribe(onNext: data.loadMore)
                .disposed(by: bag)
        }
        if data.configuration.shouldDeselect.deselectOnSelect {
            rx.itemSelected
                .subscribe(onNext: { [weak self, animated = data.configuration.shouldDeselect.animated] in
                    self?.deselectRow(at: $0, animated: animated)
                })
                .disposed(by: bag)
        }
        if let onSelect = data.onSelect {
            rx.itemSelected
                .subscribe(onNext: onSelect)
                .disposed(by: bag)
        }
    }

    private func configure() {
        if data.sectionHeaderGetter != nil {
            view.sectionHeaderHeight = UITableView.automaticDimension
            view.estimatedSectionHeaderHeight = .leastNormalMagnitude
            if #available(iOS 15.0, *) {
                view.sectionHeaderTopPadding = .leastNormalMagnitude
            }
        }
        if data.sectionFooterGetter != nil {
            view.sectionFooterHeight = UITableView.automaticDimension
            view.estimatedSectionFooterHeight = .leastNormalMagnitude
        }
        data.configuration.keyboardDismissMode.flatMap { view.keyboardDismissMode = $0 }
        data.configuration.separatorConfiguration.color.flatMap { view.separatorColor = $0 }
        view.separatorStyle = data.configuration.separatorConfiguration.style
        data.configuration.separatorConfiguration.effect.flatMap { view.separatorEffect = $0 }
        data.configuration.separatorConfiguration.insetReference.flatMap { view.separatorInsetReference = $0 }
        configureRefresh()
    }
    
    // MARK: - ASTableDelegate
    
    public func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        data.shouldBatchFetch?() ?? false
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let getter = data.sectionHeaderGetter, let section = source?[section] {
            return VANodeWrapperView(contentNode: getter(section))
        } else {
            return nil
        }
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let getter = data.sectionFooterGetter, let section = source?[section] {
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

    private func toggleRefreshIfNeeded() {
        if let reloadData = refreshData.reloadData, refreshData.isDelayed && refreshControlView.isRefreshing && !isRefreshing {
            reloadData()
        }
    }
}
