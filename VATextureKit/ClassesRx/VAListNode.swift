//
//  VAListNode.swift
//  VATextureKitRx
//
//  Created by Volodymyr Andriienko on 27.03.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
public import RxSwift
public import VATextureKit
public import Differentiator
#else
import AsyncDisplayKit
import RxSwift
import VATextureKit
import Differentiator
#endif
import RxCocoa

/// A subclass of `ASCollectionNode` that provides a configurable declarative list.
open class VAListNode<S: AnimatableSectionModelType>: VASimpleCollectionNode, ASCollectionDelegate, ASCollectionDelegateFlowLayout, @unchecked Sendable {
    public struct IndicatorConfiguration: Sendable {
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

    public struct ElementDTO: @unchecked Sendable {
        let indicatorConfiguration: IndicatorConfiguration
        let listDataObs: Observable<[S.Item]>
        let onSelect: (@Sendable (IndexPath) -> Void)?
        let shouldDeselect: (deselectOnSelect: Bool, animated: Bool)
        let cellGetter: @Sendable (S.Item) -> ASCellNode
        let headerGetter: (@Sendable (S) -> ASCellNode?)?
        let footerGetter: (@Sendable (S) -> ASCellNode?)?
        let canMoveItem: @Sendable (_ cell: ASCellNode) -> Bool
        let moveItem: (@Sendable (_ source: IndexPath, _ destination: IndexPath) -> Void)?
        let shouldBatchFetch: (@Sendable () -> Bool)?
        let loadMore: @Sendable () -> Void

        public init(
            indicatorConfiguration: IndicatorConfiguration = .init(),
            listDataObs: Observable<[S.Item]>,
            onSelect: (@Sendable (IndexPath) -> Void)? = nil,
            shouldDeselect: (deselectOnSelect: Bool, animated: Bool) = (true, true),
            cellGetter: @Sendable @escaping (S.Item) -> ASCellNode,
            headerGetter: (@Sendable (S) -> ASCellNode?)? = nil,
            footerGetter: (@Sendable (S) -> ASCellNode?)? = nil,
            canMoveItem: @Sendable @escaping (_ cell: ASCellNode) -> Bool = { _ in true },
            moveItem: (@Sendable (_ source: IndexPath, _ destination: IndexPath) -> Void)? = nil,
            shouldBatchFetch: (@Sendable () -> Bool)? = nil,
            loadMore: @Sendable @escaping () -> Void = {}
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
    
    public struct Context: @unchecked Sendable {
        let indicatorConfiguration: IndicatorConfiguration
        let listDataObs: Observable<[S]>
        let onSelect: (@Sendable (IndexPath) -> Void)?
        let shouldDeselect: (deselectOnSelect: Bool, animated: Bool)
        let cellGetter: @Sendable (S.Item) -> ASCellNode
        let headerGetter: (@Sendable (S) -> ASCellNode?)?
        let footerGetter: (@Sendable (S) -> ASCellNode?)?
        let canMoveItem: @Sendable (_ cell: ASCellNode) -> Bool
        let moveItem: (@Sendable (_ source: IndexPath, _ destination: IndexPath) -> Void)?
        let shouldBatchFetch: (@Sendable () -> Bool)?
        let loadMore: @Sendable () -> Void

        nonisolated public init(
            indicatorConfiguration: IndicatorConfiguration = .init(),
            listDataObs: Observable<[S]>,
            onSelect: (@Sendable (IndexPath) -> Void)? = nil,
            shouldDeselect: (deselectOnSelect: Bool, animated: Bool) = (true, true),
            cellGetter: @Sendable @escaping (S.Item) -> ASCellNode,
            headerGetter: (@Sendable (S) -> ASCellNode?)? = nil,
            footerGetter: (@Sendable (S) -> ASCellNode?)? = nil,
            canMoveItem: @Sendable @escaping (_ cell: ASCellNode) -> Bool = { _ in true },
            moveItem: (@Sendable (_ source: IndexPath, _ destination: IndexPath) -> Void)? = nil,
            shouldBatchFetch: (@Sendable () -> Bool)? = nil,
            loadMore: @Sendable @escaping () -> Void = {}
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
            case delegate(any ASCollectionLayoutDelegate)
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
            refreshControlView: @escaping @MainActor () -> UIRefreshControl = { .init() },
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
            self.refreshControlView = { @MainActor in .init() }
            self.isDelayed = false
            self.reloadData = nil
            self.isLoadingObs = .empty()
        }
    }
    
    public private(set) var context: Context!
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
            context: .init(
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
        context: Context,
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
                frame: .init(origin: .zero, size: .init(same: 320)),
                collectionViewLayout: flowLayout,
                layoutFacilitator: nil
            )
        case let .custom(customLayout):
            self.init(
                frame: .init(origin: .zero, size: .init(same: 320)),
                collectionViewLayout: customLayout,
                layoutFacilitator: nil
            )
        case let .delegate(layoutDelegate):
            self.init(layoutDelegate: layoutDelegate, layoutFacilitator: nil)
        }
        self.delayedConfiguration = !Thread.current.isMainThread
        self.context = context
        self.layoutData = layoutData
        self.refreshData = refreshData

        if !delayedConfiguration {
            configure()
            bind()
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        if delayedConfiguration {
            configure()
            bind()
        }
    }

    open func scrollToTop() {
        view.scrollRectToVisible(.init(size: .init(same: 1)), animated: true)
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
        if context.headerGetter != nil {
            registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
        }
        if context.footerGetter != nil {
            registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionFooter)
        }
        let context: Context = context
        let dataSource = RxASCollectionSectionedAnimatedDataSource<S>(
            animationConfiguration: layoutData.animationConfiguration,
            configureCellBlock: { [context] _, _, _, item in { context.cellGetter(item) } },
            configureSupplementaryNodeBlock: { [context] ds, _, kind, indexPath in
                guard let section = ds[safe: indexPath.section] else {
                    return nil
                }

                if kind == "UICollectionElementKindSectionHeader" {
                    return { context.headerGetter?(section) ?? ASCellNode() }
                } else {
                    return { context.footerGetter?(section) ?? ASCellNode() }
                }
            },
            moveItem: { [context] _, source, desctination in context.moveItem?(source, desctination) ?? () },
            canMoveItemWith: { [context] _, cell in context.moveItem != nil && context.canMoveItem(cell) }
        )
        if context.moveItem != nil {
            view.addGestureRecognizer(UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleLongPress(_:))
            ))
        }
        context.listDataObs
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
        if context.shouldBatchFetch != nil {
            rx.willBeginBatchFetch
                .subscribeMain(onNext: { [weak self] value in
                    self?.batchContext = value
                    context.loadMore()
                })
                .disposed(by: bag)
        }
        if context.shouldDeselect.deselectOnSelect {
            rx.itemSelected
                .subscribe(onNext: { [weak self, context] in
                    self?.deselectItem(at: $0, animated: context.shouldDeselect.animated)
                })
                .disposed(by: bag)
        }
        if let onSelect = context.onSelect {
            rx.itemSelected
                .subscribe(onNext: onSelect)
                .disposed(by: bag)
        }
        configureRefresh()
    }

    private func configure() {
        contentInset = layoutData.contentInset
        showsVerticalScrollIndicator = context.indicatorConfiguration.showsVerticalScrollIndicator
        showsHorizontalScrollIndicator = context.indicatorConfiguration.showsHorizontalScrollIndicator
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
        .init(
            min: .init(width: collectionNode.frame.width, height: .leastNormalMagnitude),
            max: .init(width: collectionNode.frame.width, height: .greatestFiniteMagnitude)
        )
    }

    public func collectionNode(_ collectionNode: ASCollectionNode, sizeRangeForFooterInSection section: Int) -> ASSizeRange {
        .init(
            min: .init(width: collectionNode.frame.width, height: .leastNormalMagnitude),
            max: .init(width: collectionNode.frame.width, height: .greatestFiniteMagnitude)
        )
    }

    public func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        context.shouldBatchFetch?() ?? false
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

#if compiler(>=6.0)
extension String: @retroactive IdentifiableType {
    public var identity: String { self }
}
extension ASBatchContext: @retroactive @unchecked Sendable {}
#else
extension String: IdentifiableType {
    public var identity: String { self }
}
extension ASBatchContext: @unchecked Sendable {}
#endif
