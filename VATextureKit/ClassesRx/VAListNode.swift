//
//  VAListNode.swift
//  VATextureKitRx
//
//  Created by Volodymyr Andriienko on 27.03.2023.
//

import AsyncDisplayKit
import VATextureKit
import RxSwift
import RxCocoa

/// A subclass of `ASCollectionNode` that provides a configurable declarative list.
open class VAListNode<S: AnimatableSectionModelType>: ASCollectionNode, ASCollectionDelegate, ASCollectionDelegateFlowLayout, Sendable {
    public struct IndicatorConfiguration {
        let showsVerticalScrollIndicator: Bool
        let showsHorizontalScrollIndicator: Bool

        public init(
            showsVerticalScrollIndicator: Bool = true,
            showsHorizontalScrollIndicator: Bool = true
        ) {
            self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
            self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        }
    }

    public struct ElementDTO {
        let indicatorConfiguration: IndicatorConfiguration
        let listDataObs: Observable<[S.Item]>
        let onSelect: ((IndexPath) -> Void)?
        let shouldDeselect: (deselectOnSelect: Bool, animated: Bool)
        let cellGetter: (S.Item) -> ASCellNode
        let headerGetter: ((S) -> ASCellNode?)?
        let footerGetter: ((S) -> ASCellNode?)?
        let canMoveItem: (_ cell: ASCellNode) -> Bool
        let moveItem: ((_ source: IndexPath, _ destination: IndexPath) -> Void)?
        let shouldBatchFetch: (() -> Bool)?
        let loadMore: () -> Void
        
        public init(
            indicatorConfiguration: IndicatorConfiguration = .init(),
            listDataObs: Observable<[S.Item]>,
            onSelect: ((IndexPath) -> Void)? = nil,
            shouldDeselect: (deselectOnSelect: Bool, animated: Bool) = (true, true),
            cellGetter: @escaping (S.Item) -> ASCellNode,
            headerGetter: ((S) -> ASCellNode?)? = nil,
            footerGetter: ((S) -> ASCellNode?)? = nil,
            canMoveItem: @escaping (_ cell: ASCellNode) -> Bool = { _ in true },
            moveItem: ((_ source: IndexPath, _ destination: IndexPath) -> Void)? = nil,
            shouldBatchFetch: (() -> Bool)? = nil,
            loadMore: @escaping () -> Void = {}
        ) {
            self.indicatorConfiguration = indicatorConfiguration
            self.listDataObs = listDataObs
            self.onSelect = onSelect
            self.shouldDeselect = shouldDeselect
            self.cellGetter = cellGetter
            self.headerGetter = headerGetter
            self.footerGetter = footerGetter
            self.moveItem = moveItem
            self.canMoveItem = canMoveItem
            self.shouldBatchFetch = shouldBatchFetch
            self.loadMore = loadMore
        }
    }
    
    public struct Context {
        let indicatorConfiguration: IndicatorConfiguration
        let listDataObs: Observable<[S]>
        let onSelect: ((IndexPath) -> Void)?
        let shouldDeselect: (deselectOnSelect: Bool, animated: Bool)
        let cellGetter: (S.Item) -> ASCellNode
        let headerGetter: ((S) -> ASCellNode?)?
        let footerGetter: ((S) -> ASCellNode?)?
        let canMoveItem: (_ cell: ASCellNode) -> Bool
        let moveItem: ((_ source: IndexPath, _ destination: IndexPath) -> Void)?
        let shouldBatchFetch: (() -> Bool)?
        let loadMore: () -> Void
        
        public init(
            indicatorConfiguration: IndicatorConfiguration = .init(),
            listDataObs: Observable<[S]>,
            onSelect: ((IndexPath) -> Void)? = nil,
            shouldDeselect: (deselectOnSelect: Bool, animated: Bool) = (true, true),
            cellGetter: @escaping (S.Item) -> ASCellNode,
            headerGetter: ((S) -> ASCellNode?)? = nil,
            footerGetter: ((S) -> ASCellNode?)? = nil,
            canMoveItem: @escaping (_ cell: ASCellNode) -> Bool = { _ in true },
            moveItem: ((_ source: IndexPath, _ destination: IndexPath) -> Void)? = nil,
            shouldBatchFetch: (() -> Bool)? = nil,
            loadMore: @escaping () -> Void = {}
        ) {
            self.indicatorConfiguration = indicatorConfiguration
            self.listDataObs = listDataObs
            self.onSelect = onSelect
            self.shouldDeselect = shouldDeselect
            self.cellGetter = cellGetter
            self.headerGetter = headerGetter
            self.footerGetter = footerGetter
            self.moveItem = moveItem
            self.canMoveItem = canMoveItem
            self.shouldBatchFetch = shouldBatchFetch
            self.loadMore = loadMore
        }
    }
    
    public struct LayoutDTO {
        public struct DefaultLayoutParameters {
            let scrollDirection: UICollectionView.ScrollDirection
            let minimumLineSpacing: CGFloat
            let minimumInteritemSpacing: CGFloat
            let sectionHeadersPinToVisibleBounds: Bool
            let sectionFootersPinToVisibleBounds: Bool

            public init(
                scrollDirection: UICollectionView.ScrollDirection = .vertical,
                minimumLineSpacing: CGFloat = .leastNormalMagnitude,
                minimumInteritemSpacing: CGFloat = .leastNormalMagnitude,
                sectionHeadersPinToVisibleBounds: Bool = false,
                sectionFootersPinToVisibleBounds: Bool = false
            ) {
                self.scrollDirection = scrollDirection
                self.minimumLineSpacing = minimumLineSpacing
                self.minimumInteritemSpacing = minimumInteritemSpacing
                self.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
                self.sectionFootersPinToVisibleBounds = sectionFootersPinToVisibleBounds
            }
        }

        public enum Layout {
            case `default`(parameters: DefaultLayoutParameters)
            case delegate(ASCollectionLayoutDelegate)
            case custom(UICollectionViewLayout)
        }

        let animationConfiguration: AnimationConfiguration
        let keyboardDismissMode: UIScrollView.KeyboardDismissMode
        let shouldScrollToTopOnDataChange: Bool
        let contentInset: UIEdgeInsets
        let sizing: VACollectionNodeSizing?
        let albumSizing: VACollectionNodeSizing?
        let layout: Layout
        
        public init(
            animationConfiguration: AnimationConfiguration = .init(),
            keyboardDismissMode: UIScrollView.KeyboardDismissMode = .none,
            shouldScrollToTopOnDataChange: Bool = false,
            contentInset: UIEdgeInsets = .zero,
            sizing: VACollectionNodeSizing? = nil,
            albumSizing: VACollectionNodeSizing? = nil,
            layout: Layout = .default(parameters: .init())
        ) {
            self.animationConfiguration = animationConfiguration
            self.keyboardDismissMode = keyboardDismissMode
            self.shouldScrollToTopOnDataChange = shouldScrollToTopOnDataChange
            self.contentInset = contentInset
            self.sizing = sizing
            self.albumSizing = albumSizing
            self.layout = layout
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
    
    public private(set) var data: Context!
    public private(set) var layoutData: LayoutDTO!
    public private(set) var refreshData: RefreshDTO!
    public private(set) var batchContext: ASBatchContext?
    
    private let bag = DisposeBag()
    private lazy var refreshControlView = refreshData.refreshControlView()
    private var isRefreshing = false
    private var delayedConfiguration: Bool!
    
    public convenience init<T>(
        data: ElementDTO,
        layoutData: LayoutDTO,
        refreshData: RefreshDTO = .init()
    ) where S == AnimatableSectionModel<String, T> {
        self.init(
            data: .init(
                indicatorConfiguration: data.indicatorConfiguration,
                listDataObs: data.listDataObs.map { $0.isEmpty ? [] : [AnimatableSectionModel(model: "", items: $0)] },
                onSelect: data.onSelect,
                shouldDeselect: data.shouldDeselect,
                cellGetter: data.cellGetter,
                headerGetter: data.headerGetter,
                footerGetter: data.footerGetter,
                canMoveItem: data.canMoveItem,
                moveItem: data.moveItem,
                shouldBatchFetch: data.shouldBatchFetch,
                loadMore: data.loadMore
            ),
            layoutData: layoutData,
            refreshData: refreshData
        )
    }

    // MARK: - `UICollectionViewFlowLayout` is marked with `@MainActor`. However, it can be created from a background thread without encountering any problems for now.
    public convenience init(
        data: Context,
        layoutData: LayoutDTO,
        refreshData: RefreshDTO = .init()
    ) {
        switch layoutData.layout {
        case let .default(parameters):
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = parameters.scrollDirection
            flowLayout.minimumLineSpacing = parameters.minimumLineSpacing
            flowLayout.minimumInteritemSpacing = parameters.minimumInteritemSpacing
            flowLayout.sectionHeadersPinToVisibleBounds = parameters.sectionHeadersPinToVisibleBounds
            flowLayout.sectionFootersPinToVisibleBounds = parameters.sectionFootersPinToVisibleBounds

            self.init(
                frame: CGRect(origin: .zero, size: CGSize(same: 320)),
                collectionViewLayout: flowLayout,
                layoutFacilitator: nil
            )
        case let .custom(customLayout):
            self.init(
                frame: CGRect(origin: .zero, size: CGSize(same: 320)),
                collectionViewLayout: customLayout,
                layoutFacilitator: nil
            )
        case let .delegate(layoutDelegate):
            self.init(layoutDelegate: layoutDelegate, layoutFacilitator: nil)
        }
        self.delayedConfiguration = !Thread.current.isMainThread
        self.data = data
        self.layoutData = layoutData
        self.refreshData = refreshData

        if !delayedConfiguration {
            configure()
            bind()
        }
    }

    @MainActor
    open override func didLoad() {
        super.didLoad()

        if delayedConfiguration {
            configure()
            bind()
        }
    }

    open func scrollToTop() {
        view.scrollRectToVisible(CGRect(size: CGSize(same: 1)), animated: true)
    }

    open func configureRefresh() {
        if refreshData.reloadData != nil {
            view.insertSubview(refreshControlView, at: 0)
            refreshControlView.rx.controlEvent(.valueChanged)
                .do(afterNext: { [weak self] _ in
                    guard let self else { return }

                    if !self.refreshData.isDelayed {
                        self.refreshData.reloadData?()
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
        if data.headerGetter != nil {
            registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
        }
        if data.footerGetter != nil {
            registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionFooter)
        }
        let data: Context = data
        let dataSource = RxASCollectionSectionedAnimatedDataSource<S>(
            animationConfiguration: layoutData.animationConfiguration,
            configureCellBlock: { [data] _, _, _, item in { data.cellGetter(item) } },
            configureSupplementaryNodeBlock: { [data] ds, _, kind, indexPath in
                guard let section = ds[safe: indexPath.section] else {
                    return nil
                }
                if kind == UICollectionView.elementKindSectionHeader {
                    return { data.headerGetter?(section) ?? ASCellNode() }
                } else {
                    return { data.footerGetter?(section) ?? ASCellNode() }
                }
            },
            moveItem: { [data] _, source, desctination in data.moveItem?(source, desctination) ?? () },
            canMoveItemWith: { [data] _, cell in data.moveItem != nil && data.canMoveItem(cell) }
        )
        if data.moveItem != nil {
            view.addGestureRecognizer(UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleLongPress(_:))
            ))
        }
        data.listDataObs
            .do(onNext: { [weak self, shouldScrollToTopOnDataChange = layoutData.shouldScrollToTopOnDataChange] _ in
                self?.batchContext?.completeBatchFetching(true)
                self?.batchContext = nil
                if shouldScrollToTopOnDataChange {
                    self?.scrollToTop()
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
        if data.shouldDeselect.deselectOnSelect {
            rx.itemSelected
                .subscribe(onNext: { [weak self, data] in
                    self?.deselectItem(at: $0, animated: data.shouldDeselect.animated)
                })
                .disposed(by: bag)
        }
        if let onSelect = data.onSelect {
            rx.itemSelected
                .subscribe(onNext: onSelect)
                .disposed(by: bag)
        }
        configureRefresh()
    }

    private func configure() {
        contentInset = layoutData.contentInset
        showsVerticalScrollIndicator = data.indicatorConfiguration.showsVerticalScrollIndicator
        showsHorizontalScrollIndicator = data.indicatorConfiguration.showsHorizontalScrollIndicator
        configureRefresh()
        view.keyboardDismissMode = layoutData.keyboardDismissMode
    }

    @objc private func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            if let indexPath = view.indexPathForItem(at: sender.location(in: view)) {
                view.beginInteractiveMovementForItem(at: indexPath)
            }
        case .changed:
            view.updateInteractiveMovementTargetPosition(sender.location(in: view))
            view.collectionViewLayout.invalidateLayout()
            invalidateCalculatedLayout()
            performBatch(animated: true, updates: nil)
        case .ended:
            view.endInteractiveMovement()
            performBatch(animated: true, updates: nil)
        case .failed, .cancelled:
            view.cancelInteractiveMovement()
        default:
            break
        }
    }
    
    // MARK: - ASCollectionDelegate

    public func collectionNode(_ collectionNode: ASCollectionNode, sizeRangeForHeaderInSection section: Int) -> ASSizeRange {
        ASSizeRange(
            min: .init(width: collectionNode.frame.width, height: .leastNormalMagnitude),
            max: .init(width: collectionNode.frame.width, height: .greatestFiniteMagnitude)
        )
    }

    public func collectionNode(_ collectionNode: ASCollectionNode, sizeRangeForFooterInSection section: Int) -> ASSizeRange {
        ASSizeRange(
            min: .init(width: collectionNode.frame.width, height: .leastNormalMagnitude),
            max: .init(width: collectionNode.frame.width, height: .greatestFiniteMagnitude)
        )
    }

    public func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        data.shouldBatchFetch?() ?? false
    }

    public func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        if let albumSizing = layoutData.albumSizing {
            return collectionNode.cellSizeRange(
                sizing: (UIApplication.shared.isAlbum ? albumSizing : layoutData.sizing) ?? (collectionNode.isHorizontal ? .entireHeightFreeWidth() : .entireWidthFreeHeight()),
                indexPath: indexPath
            )
        } else {
            return collectionNode.cellSizeRange(
                sizing: layoutData.sizing ?? (collectionNode.isHorizontal ? .entireHeightFreeWidth() : .entireWidthFreeHeight()),
                indexPath: indexPath
            )
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

public enum VACollectionNodeSizing {
    case entireWidthFreeHeight(min: CGFloat = .leastNormalMagnitude)
    case entireWidthFixedHeight(value: CGFloat)
    case entireHeightFreeWidth(min: CGFloat = .leastNormalMagnitude)
    case entireHeightFixedWidth(value: CGFloat)
    case vertical(columns: UInt, ratio: CGFloat)
    case horizontal(columns: UInt, ratio: CGFloat)
    case custom((_ collectionNode: ASCollectionNode, _ indexPath: IndexPath) -> ASSizeRange)
}

public extension ASCollectionNode {

    func cellSizeRange(sizing: VACollectionNodeSizing, indexPath: IndexPath) -> ASSizeRange {
        switch sizing {
        case let .horizontal(columns, ratio):
            let spacing = ((collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0)
            let height = ((frame.height - contentInset.vertical - spacing * CGFloat(columns - 1)) / CGFloat(columns)).rounded(.down)

            return .init(
                width: height * ratio,
                height: height
            )
        case let .vertical(columns, ratio):
            let spacing = ((collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0)
            let width = ((frame.width - contentInset.horizontal - spacing * CGFloat(columns - 1)) / CGFloat(columns)).rounded(.down)

            return .init(
                width: width,
                height: width * ratio
            )
        case let .entireHeightFixedWidth(value):
            return .init(
                width: value,
                height: frame.height - contentInset.vertical
            )
        case let .entireWidthFixedHeight(value):
            return .init(
                width: frame.width - contentInset.horizontal,
                height: value
            )
        case let .entireHeightFreeWidth(min):
            return .init(
                width: min...CGFloat.greatestFiniteMagnitude,
                height: frame.height - contentInset.vertical
            )
        case let .entireWidthFreeHeight(min):
            return .init(
                width: frame.width - contentInset.horizontal,
                height: min...CGFloat.greatestFiniteMagnitude
            )
        case let .custom(block):
            return block(self, indexPath)
        }
    }
}

extension String: IdentifiableType {
    public var identity: String { self }
}
