//
//  ASCollectionNode+Rx.swift
//  VATextureKitRx
//
//  Created by Volodymyr Andriienko on 25.03.2023.
//

import AsyncDisplayKit
import VATextureKit
import RxSwift
import RxCocoa

// swiftlint:disable indentation_width force_unwrapping implicitly_unwrapped_optional file_length
extension Reactive where Base: ASCollectionNode {
    /// Binds sequences of elements to collection node items using a custom reactive data used to perform the transformation.
    ///
    /// - parameter dataSource: Data source used to transform elements to cell nodes.
    /// - parameter source: Observable sequence of items.
    /// - returns: Disposable object that can be used to unbind.
    public func items<DataSource: RxASCollectionDataSourceType & ASCollectionDataSource, O: ObservableType>(dataSource: DataSource) -> (_ source: O) -> Disposable where DataSource.Element == O.Element {
        return { source in
            source.subscribeProxyDataSource(ofObject: base, dataSource: dataSource, retainDataSource: true) { [weak collectionNode = base] (_: RxASCollectionDataSourceProxy, event) -> Void in
                guard let collectionNode else { return }

                dataSource.collectionNode(collectionNode, observedEvent: event)
            }
        }
    }
}

extension Reactive where Base: ASCollectionNode {
    public var delegate: DelegateProxy<ASCollectionNode, ASCollectionDelegate> { RxASCollectionDelegateProxy.proxy(for: base) }
    public var dataSource: DelegateProxy<ASCollectionNode, ASCollectionDataSource> { RxASCollectionDataSourceProxy.proxy(for: base) }
    
    /// Installs data source as forwarding delegate on `rx.dataSource`.
    /// Data source won't be retained.
    
    /// It enables using normal delegate mechanism with reactive delegate mechanism.
    
    /// - parameter dataSource: Data source object.
    /// - returns: Disposable object that can be used to unbind the data source.
    public func setDataSource(_ dataSource: ASCollectionDataSource) -> Disposable {
        ScheduledDisposable(
            scheduler: MainScheduler.instance,
            disposable: RxASCollectionDataSourceProxy.installForwardDelegate(
                dataSource,
                retainDelegate: false,
                onProxyForObject: base
            )
        )
    }
    
    /// Installs delegate as forwarding delegate on `rx.delegate`.
    /// Data source won't be retained.
    
    /// It enables using normal delegate mechanism with reactive delegate mechanism.
    
    /// - parameter delegate: Delegate object
    /// - returns: Disposable object that can be used to unbind the delegate.
    public func setDelegate(_ delegate: ASCollectionDelegate) -> Disposable {
        ScheduledDisposable(
            scheduler: MainScheduler.instance,
            disposable: RxASCollectionDelegateProxy.installForwardDelegate(
                delegate,
                retainDelegate: false,
                onProxyForObject: base
            )
        )
    }
    
    public var contentOffset: ControlProperty<CGPoint> {
        mainActorEscaped {
            let bindingObserver = Binder(base) { collectionNode, contentOffset in
                collectionNode.contentOffset = contentOffset
            }

            return ControlProperty(
                values: RxASCollectionDelegateProxy.proxy(for: base).contentOffsetBehaviorSubject,
                valueSink: bindingObserver
            )
        }()
    }
    public var didScroll: ControlEvent<Void> {
        mainActorEscaped {
            ControlEvent(events: RxASCollectionDelegateProxy.proxy(for: base).contentOffsetPublishSubject)
        }()
    }
    public var willBeginDecelerating: ControlEvent<Void> {
        ControlEvent(events: delegate.methodInvoked(#selector(ASCollectionDelegate.scrollViewWillBeginDecelerating(_:))).map { _ in })
    }
    public var didEndDecelerating: ControlEvent<Void> {
        ControlEvent(events: delegate.methodInvoked(#selector(ASCollectionDelegate.scrollViewDidEndDecelerating(_:))).map { _ in })
    }
    public var willBeginDragging: ControlEvent<Void> {
        ControlEvent(events: delegate.methodInvoked(#selector(ASCollectionDelegate.scrollViewWillBeginDragging(_:))).map { _ in })
    }
    public var willEndDragging: ControlEvent<Reactive<UIScrollView>.WillEndDraggingEvent> {
        let source = delegate.methodInvoked(#selector(ASCollectionDelegate.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)))
            .map { value -> Reactive<UIScrollView>.WillEndDraggingEvent in
                let velocity = try castOrThrow(CGPoint.self, value[1])
                let targetContentOffsetValue = try castOrThrow(NSValue.self, value[2])
                guard let rawPointer = targetContentOffsetValue.pointerValue else { throw RxCocoaError.unknown }
                let typedPointer = rawPointer.bindMemory(to: CGPoint.self, capacity: MemoryLayout<CGPoint>.size)
                return (velocity, typedPointer)
            }

        return ControlEvent(events: source)
    }
    public var didEndDragging: ControlEvent<Bool> {
        let source = delegate.methodInvoked(#selector(ASCollectionDelegate.scrollViewDidEndDragging(_:willDecelerate:))).map { value -> Bool in
            return try castOrThrow(Bool.self, value[1])
        }

        return ControlEvent(events: source)
    }
    public var itemSelected: ControlEvent<IndexPath> {
        let source = delegate.methodInvoked(#selector(ASCollectionDelegate.collectionNode(_:didSelectItemAt:)))
            .map { try castOrThrow(IndexPath.self, $0[1]) }

        return ControlEvent(events: source)
    }
    public var itemDeselected: ControlEvent<IndexPath> {
        let source = delegate.methodInvoked(#selector(ASCollectionDelegate.collectionNode(_:didDeselectItemAt:)))
            .map { try castOrThrow(IndexPath.self, $0[1]) }

        return ControlEvent(events: source)
    }
    public var itemHighlighted: ControlEvent<IndexPath> {
        let source = delegate.methodInvoked(#selector(ASCollectionDelegate.collectionNode(_:didHighlightItemAt:)))
            .map { try castOrThrow(IndexPath.self, $0[1]) }

        return ControlEvent(events: source)
    }
    public var itemUnhighlighted: ControlEvent<IndexPath> {
        let source = delegate.methodInvoked(#selector(ASCollectionDelegate.collectionNode(_:didUnhighlightItemAt:)))
            .map { try castOrThrow(IndexPath.self, $0[1]) }

        return ControlEvent(events: source)
    }
    public var willDisplayItem: ControlEvent<ASCellNode> {
        let source: Observable<ASCellNode> = delegate.methodInvoked(#selector(ASCollectionDelegate.collectionNode(_:willDisplayItemWith:)))
            .map { try castOrThrow(ASCellNode.self, $0[1]) }

        return ControlEvent(events: source)
    }
    public var willDisplaySupplementaryElement: ControlEvent<ASCellNode> {
        let source: Observable<ASCellNode> = delegate.methodInvoked(#selector(ASCollectionDelegate.collectionNode(_:willDisplaySupplementaryElementWith:)))
            .map { try castOrThrow(ASCellNode.self, $0[1]) }

        return ControlEvent(events: source)
    }
    public var didEndDisplayingItem: ControlEvent<ASCellNode> {
        let source: Observable<ASCellNode> = delegate.methodInvoked(#selector(ASCollectionDelegate.collectionNode(_:didEndDisplayingItemWith:)))
            .map { try castOrThrow(ASCellNode.self, $0[1]) }

        return ControlEvent(events: source)
    }
    public var didEndDisplayingSupplementaryElement: ControlEvent<ASCellNode> {
        let source: Observable<ASCellNode> = delegate.methodInvoked(#selector(ASCollectionDelegate.collectionNode(_:didEndDisplayingSupplementaryElementWith:)))
            .map { try castOrThrow(ASCellNode.self, $0[1]) }

        return ControlEvent(events: source)
    }
    public var willBeginBatchFetch: ControlEvent<ASBatchContext> {
        let source: Observable<ASBatchContext> = delegate.methodInvoked(#selector(ASCollectionDelegate.collectionNode(_:willBeginBatchFetchWith:)))
            .map { try castOrThrow(ASBatchContext.self, $0[1]) }

        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `delegate` message `collectionNode(_:didSelectItemAtIndexPath:)`.
    ///
    /// It can be only used when one of the `rx.itemsWith*` methods is used to bind observable sequence,
    /// or any other data source conforming to `SectionedViewDataSourceType` protocol.
    ///
    /// ```
    ///     collectionNode.rx.modelSelected(MyModel.self)
    ///        .map { ...
    /// ```
    public func modelSelected<T>(_ modelType: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = itemSelected.flatMap { [weak node = base as ASCollectionNode] indexPath -> Observable<T> in
            guard let node else {
                return Observable.empty()
            }

            return Observable.just(try node.rx.model(at: indexPath))
        }

        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `delegate` message `collectionNode(_:didSelectItemAtIndexPath:)`.
    ///
    /// It can be only used when one of the `rx.itemsWith*` methods is used to bind observable sequence,
    /// or any other data source conforming to `SectionedViewDataSourceType` protocol.
    ///
    /// ```
    ///     collectionNode.rx.modelDeselected(MyModel.self)
    ///        .map { ...
    /// ```
    public func modelDeselected<T>(_ modelType: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = itemDeselected.flatMap { [weak node = base as ASCollectionNode] indexPath -> Observable<T> in
            guard let node else {
                return Observable.empty()
            }

            return Observable.just(try node.rx.model(at: indexPath))
        }

        return ControlEvent(events: source)
    }
    
    /// Synchronous helper method for retrieving a model at indexPath through a reactive data source
    public func model<T>(at indexPath: IndexPath) throws -> T {
        let dataSource: SectionedViewDataSourceType = castOrFatalError(dataSource.forwardToDelegate(), message: "This method only works in case one of the `rx.itemsWith*` methods was used.")
        let element = try dataSource.model(at: indexPath)

        return try castOrThrow(T.self, element)
    }
}

/// Marks data source as `ASCollectionNode` reactive data source enabling it to be used with one of the `bindTo` methods.
public protocol RxASCollectionDataSourceType {
    associatedtype Element
    
    /// New observable sequence event observed.
    ///
    /// - parameter collectionNode: Bound collection node.
    /// - parameter observedEvent: Event
    func collectionNode(_ collectionNode: ASCollectionNode, observedEvent: Event<Element>)
}

open class RxASCollectionSectionedAnimatedDataSource<S: AnimatableSectionModelType>: ASCollectionSectionedDataSource<S>, RxASCollectionDataSourceType {
    public typealias Element = [S]
    public typealias DecideNodeTransition = (ASCollectionSectionedDataSource<S>, ASCollectionNode, [Changeset<S>]) -> NodeTransition
    public var animationConfiguration: AnimationConfiguration
    public var decideNodeTransition: DecideNodeTransition
    
    public init(
        animationConfiguration: AnimationConfiguration = AnimationConfiguration(),
        decideNodeTransition: @escaping DecideNodeTransition = { _, _, _ in .animated },
        configureCellBlock: @escaping ConfigureCellBlock,
        configureSupplementaryNodeBlock: ConfigureSupplementaryNodeBlock? = nil,
        moveItem: @escaping MoveItem = { _, _, _ in () },
        canMoveItemWith: @escaping CanMoveItemWith = { _, _ in false }
    ) {
        self.animationConfiguration = animationConfiguration
        self.decideNodeTransition = decideNodeTransition
        
        super.init(
            configureCellBlock: configureCellBlock,
            configureSupplementaryNodeBlock: configureSupplementaryNodeBlock,
            moveItem: moveItem,
            canMoveItemWith: canMoveItemWith
        )
    }
    
    // there is no longer limitation to load initial sections with reloadData
    // but it is kept as a feature everyone got used to
    var dataSet = false
    
    open func collectionNode(_ collectionNode: ASCollectionNode, observedEvent: Event<Element>) {
        Binder(self) { dataSource, newSections in
            #if DEBUG
            dataSource._dataSourceBound = true
            #endif
            if !dataSource.dataSet {
                dataSource.dataSet = true
                dataSource.setSections(newSections)
                mainActorEscaped {
                    collectionNode.reloadDataWithoutAnimations()
                }()
            } else {
                if dataSource.animationConfiguration.animated {
                    let oldSections = dataSource.sectionModels
                    do {
                        let differences = try Diff.differencesForSectionedView(initialSections: oldSections, finalSections: newSections)
                        switch dataSource.decideNodeTransition(dataSource, collectionNode, differences) {
                        case .animated:
                            // each difference must be run in a separate 'performBatchUpdates', otherwise it crashes.
                            // this is a limitation of Diff tool
                            for difference in differences {
                                let updateBlock = {
                                    // sections must be set within updateBlock in 'performBatchUpdates'
                                    dataSource.setSections(difference.finalSections)
                                    collectionNode.batchUpdates(difference, animationConfiguration: dataSource.animationConfiguration)
                                }
                                mainActorEscaped {
                                    collectionNode.performBatch(
                                        animated: dataSource.animationConfiguration.animated,
                                        updates: updateBlock,
                                        completion: nil
                                    )
                                }()
                            }
                        case .reload:
                            dataSource.setSections(newSections)
                            mainActorEscaped {
                                collectionNode.reloadDataWithoutAnimations()
                            }()

                            return
                        }
                    } catch {
                        rxDebugFatalError(error)
                        dataSource.setSections(newSections)
                        mainActorEscaped {
                            collectionNode.reloadDataWithoutAnimations()
                        }()
                    }
                } else {
                    dataSource.setSections(newSections)
                    mainActorEscaped {
                        collectionNode.reloadDataWithoutAnimations()
                    }()
                }
            }
        }
        .on(observedEvent)
    }
}

open class RxASCollectionSectionedReloadDataSource<S: SectionModelType>: ASCollectionSectionedDataSource<S>, RxASCollectionDataSourceType {
    public typealias Element = [S]
    
    open func collectionNode(_ collectionNode: ASCollectionNode, observedEvent: Event<[S]>) {
        Binder(self) { dataSource, element in
            #if DEBUG
            dataSource._dataSourceBound = true
            #endif
            dataSource.setSections(element)
            mainActorEscaped {
                collectionNode.reloadData()
                collectionNode.collectionViewLayout.invalidateLayout()
            }()
        }
        .on(observedEvent)
    }
}

extension ASCollectionNode: HasDelegate {
    public typealias Delegate = ASCollectionDelegate
}

/// For more information take a look at `DelegateProxyType`.
open class RxASCollectionDelegateProxy: DelegateProxy<ASCollectionNode, ASCollectionDelegate>, DelegateProxyType, ASCollectionDelegate, ASCollectionDelegateFlowLayout, UICollectionViewDelegateFlowLayout {
    /// Typed parent object.
    public weak private(set) var collectionNode: ASCollectionNode?
    
    /// - parameter tableNode: Parent object for delegate proxy.
    public init(collectionNode: ASCollectionNode) {
        self.collectionNode = collectionNode
        
        super.init(parentObject: collectionNode, delegateProxy: RxASCollectionDelegateProxy.self)
    }
    
    // Register known implementations
    public static func registerKnownImplementations() {
        register { RxASCollectionDelegateProxy(collectionNode: $0) }
    }
    
    private var _contentOffsetBehaviorSubject: BehaviorSubject<CGPoint>?
    private var _contentOffsetPublishSubject: PublishSubject<Void>?
    
    /// Optimized version used for observing content offset changes.
    internal var contentOffsetBehaviorSubject: BehaviorSubject<CGPoint> {
        if let subject = _contentOffsetBehaviorSubject {
            return subject
        }

        let subject = BehaviorSubject<CGPoint>(value: collectionNode?.contentOffset ?? .zero)
        _contentOffsetBehaviorSubject = subject

        return subject
    }
    
    /// Optimized version used for observing content offset changes.
    internal var contentOffsetPublishSubject: PublishSubject<Void> {
        if let subject = _contentOffsetPublishSubject {
            return subject
        }

        let subject = PublishSubject<Void>()
        _contentOffsetPublishSubject = subject

        return subject
    }
    
    // MARK: delegate methods
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _contentOffsetBehaviorSubject?.on(.next(scrollView.contentOffset))
        _contentOffsetPublishSubject?.on(.next(()))
        _forwardToDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    deinit {
        _contentOffsetBehaviorSubject?.on(.completed)
        _contentOffsetPublishSubject?.on(.completed)
    }
}

open class ASCollectionSectionedDataSource<S: SectionModelType>: NSObject, ASCollectionDataSource, SectionedViewDataSourceType {
    public typealias Item = S.Item
    public typealias Section = S
    
    public typealias ConfigureCellBlock = (ASCollectionSectionedDataSource<S>, ASCollectionNode, IndexPath, Item) -> ASCellNodeBlock
    public typealias ConfigureSupplementaryNodeBlock = (ASCollectionSectionedDataSource<S>, ASCollectionNode, String, IndexPath) -> ASCellNodeBlock?
    public typealias MoveItem = (ASCollectionSectionedDataSource<S>, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void
    public typealias CanMoveItemWith = (ASCollectionSectionedDataSource<S>, ASCellNode) -> Bool
    
    public init(
        configureCellBlock: @escaping ConfigureCellBlock,
        configureSupplementaryNodeBlock: ConfigureSupplementaryNodeBlock? = nil,
        moveItem: @escaping MoveItem = { _, _, _ in () },
        canMoveItemWith: @escaping CanMoveItemWith = { _, _ in false }
    ) {
        self.configureCellBlock = configureCellBlock
        self.configureSupplementaryNodeBlock = configureSupplementaryNodeBlock
        self.moveItem = moveItem
        self.canMoveItemWith = canMoveItemWith
    }
    
    #if DEBUG
    // If data source has already been bound, then mutating it
    // afterwards isn't something desired.
    // This simulates immutability after binding
    var _dataSourceBound = false
    
    private func ensureNotMutatedAfterBinding() {
        assert(!_dataSourceBound, "Data source is already bound. Please write this line before binding call (`bindTo`, `drive`). Data source must first be completely configured, and then bound after that.")
    }
    #endif
    
    // This structure exists because model can be mutable
    // In that case current state value should be preserved.
    // The state that needs to be preserved is ordering of items in section
    // and their relationship with section.
    // If particular item is mutable, that is irrelevant for this logic to function
    // properly.
    public typealias SectionModelSnapshot = SectionModel<S, Item>
    
    private var _sectionModels: [SectionModelSnapshot] = []
    
    open var sectionModels: [S] { _sectionModels.map { Section(original: $0.model, items: $0.items) } }
    
    open subscript(section: Int) -> S {
        let sectionModel = _sectionModels[section]
        
        return S(original: sectionModel.model, items: sectionModel.items)
    }

    open subscript(safe section: Int) -> S? {
        guard _sectionModels.indices ~= section else {
            return nil
        }

        let sectionModel = _sectionModels[section]

        return S(original: sectionModel.model, items: sectionModel.items)
    }
    
    open subscript(indexPath: IndexPath) -> Item {
        get { _sectionModels[indexPath.section].items[indexPath.item] }
        set {
            var section = _sectionModels[indexPath.section]
            section.items[indexPath.item] = newValue
            _sectionModels[indexPath.section] = section
        }
    }
    
    open func model(at indexPath: IndexPath) throws -> Any {
        guard indexPath.section < _sectionModels.count, indexPath.item < _sectionModels[indexPath.section].items.count else {
            throw RxDataSourceTextureError.outOfBounds(indexPath: indexPath)
        }

        return self[indexPath]
    }
    
    open func setSections(_ sections: [S]) {
        _sectionModels = sections.map { SectionModelSnapshot(model: $0, items: $0.items) }
    }
    
    open var configureCellBlock: ConfigureCellBlock {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    open var configureSupplementaryNodeBlock: ConfigureSupplementaryNodeBlock? {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    open var moveItem: MoveItem {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    open var canMoveItemWith: ((ASCollectionSectionedDataSource<S>, ASCellNode) -> Bool)? {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    // ASCollectionDataSource
    
    open func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        _sectionModels.count
    }
    
    open func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        _sectionModels[section].items.count
    }
    
    open func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        precondition(indexPath.item < _sectionModels[indexPath.section].items.count)

        return configureCellBlock(self, collectionNode, indexPath, self[indexPath])
    }

    public func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNodeBlock {
        configureSupplementaryNodeBlock?(self, collectionNode, kind, indexPath) ?? { ASCellNode().sized(.zero) }
    }
    
    open func collectionNode(_ collectionNode: ASCollectionNode, canMoveItemWith node: ASCellNode) -> Bool {
        guard let canMoveItem = canMoveItemWith?(self, node) else {
            return false
        }
        
        return canMoveItem
    }
    
    open func collectionNode(_ collectionNode: ASCollectionNode, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        _sectionModels.moveFromSourceIndexPath(sourceIndexPath, destinationIndexPath: destinationIndexPath)
        moveItem(self, sourceIndexPath, destinationIndexPath)
    }
    
    open override func responds(to aSelector: Selector!) -> Bool {
        if aSelector == #selector(ASCollectionDataSource.collectionNode(_:nodeBlockForSupplementaryElementOfKind:at:)) {
            return configureSupplementaryNodeBlock != nil
        } else {
            return super.responds(to: aSelector)
        }
    }
}

extension ASCollectionNode: HasDataSource {
    public typealias DataSource = ASCollectionDataSource
}

private let collectionDataSourceNotSet = ASCollectionDataSourceNotSet()

final class ASCollectionDataSourceNotSet: NSObject, ASCollectionDataSource {
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        rxAbstractMethod(message: dataSourceNotSet)
    }
}

/// For more information take a look at `DelegateProxyType`.
final class RxASCollectionDataSourceProxy: DelegateProxy<ASCollectionNode, ASCollectionDataSource>, DelegateProxyType, ASCollectionDataSource {
    public weak private(set) var collectionNode: ASCollectionNode?
    
    public init(collectionNode: ASCollectionNode) {
        self.collectionNode = collectionNode
        
        super.init(parentObject: collectionNode, delegateProxy: RxASCollectionDataSourceProxy.self)
    }
    
    public static func registerKnownImplementations() {
        register { RxASCollectionDataSourceProxy(collectionNode: $0) }
    }
    
    private weak var _requiredMethodsDataSource: ASCollectionDataSource? = collectionDataSourceNotSet
    
    // MARK: DataSource
    
    public func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        (_requiredMethodsDataSource ?? collectionDataSourceNotSet).collectionNode!(collectionNode, numberOfItemsInSection: section)
    }
    
    public func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        (_requiredMethodsDataSource ?? collectionDataSourceNotSet).collectionNode!(collectionNode, nodeBlockForItemAt: indexPath)
    }
    
    public override func setForwardToDelegate(_ forwardToDelegate: ASCollectionDataSource?, retainDelegate: Bool) {
        _requiredMethodsDataSource = forwardToDelegate ?? collectionDataSourceNotSet
        
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
}
