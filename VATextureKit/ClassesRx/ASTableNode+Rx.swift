//
//  ASTableNode+Rx.swift
//  VATextureKitRx
//
//  Created by Volodymyr Andriienko on 25.03.2023.
//

import AsyncDisplayKit
import VATextureKit
import RxSwift
import RxCocoa
import Differentiator

// swiftlint:disable indentation_width force_unwrapping implicitly_unwrapped_optional file_length
extension Reactive where Base: ASTableNode {
    /// Binds sequences of elements to table node rows using a custom reactive data used to perform the transformation.
    /// This method will retain the data source for as long as the subscription isn't disposed (result `Disposable`
    /// being disposed).
    /// In case `source` observable sequence terminates successfully, the data source will present latest element
    /// until the subscription isn't disposed.
    ///
    /// - parameter dataSource: Data source used to transform elements to cell nodes.
    /// - parameter source: Observable sequence of items.
    /// - returns: Disposable object that can be used to unbind.
    public func items<DataSource: RxASTableDataSourceType & ASTableDataSource, O: ObservableType>(dataSource: DataSource) -> (_ source: O) -> Disposable where DataSource.Element == O.Element {
        return { source in
            // Strong reference is needed because data source is in use until result subscription is disposed
            source.subscribeProxyDataSource(ofObject: base, dataSource: dataSource as ASTableDataSource, retainDataSource: true) { [weak tableNode = base] (_: RxASTableDataSourceProxy, event) -> Void in
                guard let tableNode else { return }

                dataSource.tableNode(tableNode, observedEvent: event)
            }
        }
    }
}

extension Reactive where Base: ASTableNode {
    public var delegate: DelegateProxy<ASTableNode, ASTableDelegate> { RxASTableDelegateProxy.proxy(for: base) }
    public var dataSource: DelegateProxy<ASTableNode, ASTableDataSource> { RxASTableDataSourceProxy.proxy(for: base) }
    
    /// Installs data source as forwarding delegate on `rx.dataSource`.
    /// Data source won't be retained.
    ///
    /// It enables using normal delegate mechanism with reactive delegate mechanism.
    ///
    /// - parameter dataSource: Data source object.
    /// - returns: Disposable object that can be used to unbind the data source.
    public func setDataSource(_ dataSource: ASTableDataSource) -> Disposable {
        ScheduledDisposable(
            scheduler: MainScheduler.instance,
            disposable: RxASTableDataSourceProxy.installForwardDelegate(
                dataSource,
                retainDelegate: false,
                onProxyForObject: base
            )
        )
    }
    
    /// Installs delegate as forwarding delegate on `rx.delegate`.
    /// Data source won't be retained.
    ///
    /// It enables using normal delegate mechanism with reactive delegate mechanism.
    ///
    /// - parameter delegate: Delegate object
    /// - returns: Disposable object that can be used to unbind the delegate.
    public func setDelegate(_ delegate: ASTableDelegate) -> Disposable {
        ScheduledDisposable(
            scheduler: MainScheduler.instance,
            disposable: RxASTableDelegateProxy.installForwardDelegate(
                delegate,
                retainDelegate: false,
                onProxyForObject: base
            )
        )
    }
    
    public var contentOffset: ControlProperty<CGPoint> {
        let proxy = RxASTableDelegateProxy.proxy(for: base)
        let bindingObserver = Binder(base) { tableNode, contentOffset in
            tableNode.contentOffset = contentOffset
        }

        return mainActorEscaped {
            ControlProperty(values: proxy.contentOffsetBehaviorSubject, valueSink: bindingObserver)
        }()
    }
    public var didScroll: ControlEvent<Void> {
        mainActorEscaped {
            ControlEvent(events: RxASTableDelegateProxy.proxy(for: base).contentOffsetPublishSubject)
        }()
    }
    public var willBeginDecelerating: ControlEvent<Void> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewWillBeginDecelerating(_:))).map { _ in }

        return ControlEvent(events: source)
    }
    public var didEndDecelerating: ControlEvent<Void> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewDidEndDecelerating(_:))).map { _ in }

        return ControlEvent(events: source)
    }
    public var willBeginDragging: ControlEvent<Void> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewWillBeginDragging(_:))).map { _ in }

        return ControlEvent(events: source)
    }
    public var willEndDragging: ControlEvent<Reactive<UIScrollView>.WillEndDraggingEvent> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)))
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
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewDidEndDragging(_:willDecelerate:))).map { try castOrThrow(Bool.self, $0[1]) }

        return ControlEvent(events: source)
    }
    public var itemSelected: ControlEvent<IndexPath> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.tableNode(_:didSelectRowAt:)))
            .map { try castOrThrow(IndexPath.self, $0[1]) }

        return ControlEvent(events: source)
    }
    public var itemDeselected: ControlEvent<IndexPath> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.tableNode(_:didDeselectRowAt:)))
            .map { try castOrThrow(IndexPath.self, $0[1]) }

        return ControlEvent(events: source)
    }
    public var itemInserted: ControlEvent<IndexPath> {
        let source = dataSource.methodInvoked(#selector(ASTableDataSource.tableView(_:commit:forRowAt:)))
            .filter { UITableViewCell.EditingStyle(rawValue: (try castOrThrow(NSNumber.self, $0[1])).intValue) == .insert }
            .map { try castOrThrow(IndexPath.self, $0[2]) }

        return ControlEvent(events: source)
    }
    public var itemDeleted: ControlEvent<IndexPath> {
        let source = dataSource.methodInvoked(#selector(ASTableDataSource.tableView(_:commit:forRowAt:)))
            .filter { UITableViewCell.EditingStyle(rawValue: (try castOrThrow(NSNumber.self, $0[1])).intValue) == .delete }
            .map { try castOrThrow(IndexPath.self, $0[2]) }

        return ControlEvent(events: source)
    }
    public var itemMoved: ControlEvent<ItemMovedEvent> {
        let source: Observable<ItemMovedEvent> = dataSource.methodInvoked(#selector(ASTableDataSource.tableView(_:moveRowAt:to:)))
            .map { (try castOrThrow(IndexPath.self, $0[1]), try castOrThrow(IndexPath.self, $0[2])) }

        return ControlEvent(events: source)
    }
    public var willDisplayCell: ControlEvent<ASCellNode> {
        let source: Observable<ASCellNode> = delegate.methodInvoked(#selector(ASTableDelegate.tableNode(_:willDisplayRowWith:)))
            .map { try castOrThrow(ASCellNode.self, $0[1]) }

        return ControlEvent(events: source)
    }
    public var didEndDisplayingCell: ControlEvent<ASCellNode> {
        let source: Observable<ASCellNode> = delegate.methodInvoked(#selector(ASTableDelegate.tableNode(_:didEndDisplayingRowWith:)))
            .map { try castOrThrow(ASCellNode.self, $0[1]) }

        return ControlEvent(events: source)
    }
    public var willBeginBatchFetch: ControlEvent<ASBatchContext> {
        let source: Observable<ASBatchContext> = delegate.methodInvoked(#selector(ASTableDelegate.tableNode(_:willBeginBatchFetchWith:)))
            .map { try castOrThrow(ASBatchContext.self, $0[1]) }

        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `delegate` message `tableNode:didSelectRowAtIndexPath:`.
    ///
    /// It can be only used when one of the `rx.itemsWith*` methods is used to bind observable sequence,
    /// or any other data source conforming to `SectionedViewDataSourceType` protocol.
    ///
    /// ```
    /// tableNode.rx.modelSelected(MyModel.self)
    /// .map { ...
    /// ```
    public func modelSelected<T>(_ modelType: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = itemSelected.flatMap { [weak view = base as ASTableNode] indexPath -> Observable<T> in
            guard let view else {
                return Observable.empty()
            }

            return Observable.just(try view.rx.model(at: indexPath))
        }

        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `delegate` message `tableNode:didDeselectRowAtIndexPath:`.
    ///
    /// It can be only used when one of the `rx.itemsWith*` methods is used to bind observable sequence,
    /// or any other data source conforming to `SectionedViewDataSourceType` protocol.
    ///
    /// ```
    /// tableNode.rx.modelDeselected(MyModel.self)
    /// .map { ...
    /// ```
    public func modelDeselected<T>(_ modelType: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = itemDeselected.flatMap { [weak view = base as ASTableNode] indexPath -> Observable<T> in
            guard let view else {
                return Observable.empty()
            }

            return Observable.just(try view.rx.model(at: indexPath))
        }

        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `delegate` message `tableNode:commitEditingStyle:forRowAtIndexPath:`.
    ///
    /// It can be only used when one of the `rx.itemsWith*` methods is used to bind observable sequence,
    /// or any other data source conforming to `SectionedViewDataSourceType` protocol.
    ///
    /// ```
    /// tableNode.rx.modelDeleted(MyModel.self)
    /// .map { ...
    /// ```
    public func modelDeleted<T>(_ modelType: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = itemDeleted.flatMap { [weak view = base as ASTableNode] indexPath -> Observable<T> in
            guard let view else {
                return Observable.empty()
            }

            return Observable.just(try view.rx.model(at: indexPath))
        }

        return ControlEvent(events: source)
    }
    
    /// Synchronous helper method for retrieving a model at indexPath through a reactive data source.
    public func model<T>(at indexPath: IndexPath) throws -> T {
        let dataSource: SectionedViewDataSourceType = castOrFatalError(dataSource.forwardToDelegate(), message: "This method only works in case one of the `rx.items*` methods was used.")
        let element = try dataSource.model(at: indexPath)

        return castOrFatalError(element)
    }
}

open class ASTableSectionedDataSource<S: SectionModelType>: NSObject, ASTableDataSource, SectionedViewDataSourceType {
    public typealias Item = S.Item
    public typealias Section = S
    
    public typealias ConfigureCellBlock = (ASTableSectionedDataSource<S>, ASTableNode, IndexPath, Item) -> ASCellNodeBlock
    public typealias TitleForHeaderInSection = (ASTableSectionedDataSource<S>, Int) -> String?
    public typealias TitleForFooterInSection = (ASTableSectionedDataSource<S>, Int) -> String?
    public typealias CanEditRowAtIndexPath = (ASTableSectionedDataSource<S>, IndexPath) -> Bool
    public typealias CanMoveRowAtIndexPath = (ASTableSectionedDataSource<S>, IndexPath) -> Bool
    
    #if os(iOS)
    public typealias SectionIndexTitles = (ASTableSectionedDataSource<S>) -> [String]?
    public typealias SectionForSectionIndexTitle = (ASTableSectionedDataSource<S>, _ title: String, _ index: Int) -> Int
    #endif
    
    #if os(iOS)
    public init(
        configureCellBlock: @escaping ConfigureCellBlock,
        titleForHeaderInSection: @escaping TitleForHeaderInSection = { _, _ in nil },
        titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
        canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
        canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
        sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
        sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index }
    ) {
        self.configureCellBlock = configureCellBlock
        self.titleForHeaderInSection = titleForHeaderInSection
        self.titleForFooterInSection = titleForFooterInSection
        self.canEditRowAtIndexPath = canEditRowAtIndexPath
        self.canMoveRowAtIndexPath = canMoveRowAtIndexPath
        self.sectionIndexTitles = sectionIndexTitles
        self.sectionForSectionIndexTitle = sectionForSectionIndexTitle
    }
    
    #else
    public init(
        configureCellBlock: @escaping configureCellBlock,
        titleForHeaderInSection: @escaping TitleForHeaderInSection = { _, _ in nil },
        titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
        canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
        canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false }
    ) {
        self.configureCellBlock = configureCellBlock
        self.titleForHeaderInSection = titleForHeaderInSection
        self.titleForFooterInSection = titleForFooterInSection
        self.canEditRowAtIndexPath = canEditRowAtIndexPath
        self.canMoveRowAtIndexPath = canMoveRowAtIndexPath
    }
    #endif
    
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
        get { _sectionModels[indexPath.section].items[indexPath.row] }
        set {
            var section = _sectionModels[indexPath.section]
            section.items[indexPath.row] = newValue
            _sectionModels[indexPath.section] = section
        }
    }
    
    open func model(at indexPath: IndexPath) throws -> Any {
        guard indexPath.section < _sectionModels.count, indexPath.row < _sectionModels[indexPath.section].items.count else {
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
    
    open var titleForHeaderInSection: TitleForHeaderInSection {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    open var titleForFooterInSection: TitleForFooterInSection {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    open var canEditRowAtIndexPath: CanEditRowAtIndexPath {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    open var canMoveRowAtIndexPath: CanMoveRowAtIndexPath {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    #if os(iOS)
    open var sectionIndexTitles: SectionIndexTitles {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    open var sectionForSectionIndexTitle: SectionForSectionIndexTitle {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    #endif
    
    // ASTableDataSource
    
    open func numberOfSections(in tableNode: ASTableNode) -> Int {
        _sectionModels.count
    }
    
    open func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        guard _sectionModels.count > section else {
            return 0
        }

        return _sectionModels[section].items.count
    }
    
    public func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        precondition(indexPath.row < _sectionModels[indexPath.section].items.count)

        return configureCellBlock(self, tableNode, indexPath, self[indexPath])
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        titleForHeaderInSection(self, section)
    }
    
    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        titleForFooterInSection(self, section)
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        canEditRowAtIndexPath(self, indexPath)
    }
    
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        canMoveRowAtIndexPath(self, indexPath)
    }
    
    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        _sectionModels.moveFromSourceIndexPath(sourceIndexPath, destinationIndexPath: destinationIndexPath)
    }
    
    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sectionIndexTitles(self)
    }
    
    open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        sectionForSectionIndexTitle(self, title, index)
    }
}

open class RxASTableSectionedAnimatedDataSource<S: AnimatableSectionModelType>: ASTableSectionedDataSource<S>, RxASTableDataSourceType {
    public typealias Element = [S]
    public typealias DecideNodeTransition = (ASTableSectionedDataSource<S>, ASTableNode, [Changeset<S>]) -> NodeTransition
    public var animationConfiguration: AnimationConfiguration
    public var decideNodeTransition: DecideNodeTransition
    
    private var dataSet = false
    
    #if os(iOS)
    public init(
        animationConfiguration: AnimationConfiguration = AnimationConfiguration(),
        decideNodeTransition: @escaping DecideNodeTransition = { _, _, _ in .animated },
        configureCellBlock: @escaping ConfigureCellBlock,
        titleForHeaderInSection: @escaping TitleForHeaderInSection = { _, _ in nil },
        titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
        canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
        canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
        sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
        sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index }
    ) {
        self.animationConfiguration = animationConfiguration
        self.decideNodeTransition = decideNodeTransition
        
        super.init(
            configureCellBlock: configureCellBlock,
            titleForHeaderInSection: titleForHeaderInSection,
            titleForFooterInSection: titleForFooterInSection,
            canEditRowAtIndexPath: canEditRowAtIndexPath,
            canMoveRowAtIndexPath: canMoveRowAtIndexPath,
            sectionIndexTitles: sectionIndexTitles,
            sectionForSectionIndexTitle: sectionForSectionIndexTitle
        )
    }
    #else

    public init(
        animationConfiguration: AnimationConfiguration = AnimationConfiguration(),
        decideNodeTransition: @escaping DecideNodeTransition = { _, _, _ in .animated },
        configureCellBlock: @escaping ConfigureCellBlock,
        titleForHeaderInSection: @escaping TitleForHeaderInSection = { _, _ in nil },
        titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
        canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
        canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false }
    ) {
        self.animationConfiguration = animationConfiguration
        self.decideNodeTransition = decideNodeTransition
        
        super.init(
            configureCellBlock: configureCellBlock,
            titleForHeaderInSection: titleForHeaderInSection,
            titleForFooterInSection: titleForFooterInSection,
            canEditRowAtIndexPath: canEditRowAtIndexPath,
            canMoveRowAtIndexPath: canMoveRowAtIndexPath
        )
    }
    #endif
    
    public func tableNode(_ tableNode: ASTableNode, observedEvent: Event<[S]>) {
        Binder(self) { dataSource, newSections in
            #if DEBUG
            dataSource._dataSourceBound = true
            #endif
            if !dataSource.dataSet {
                dataSource.dataSet = true
                dataSource.setSections(newSections)
                if dataSource.animationConfiguration.animatedOnInit {
                    tableNode.reloadData()
                } else {
                    // Because of
                    // [self endUpdatesAnimated:[UIView areAnimationsEnabled] completion:completion];
                    // in ASTableNode
                    tableNode.reloadDataWithoutAnimations()
                }
            } else {
                if dataSource.animationConfiguration.animated {
                    let oldSections = dataSource.sectionModels
                    do {
                        let differences = try Diff.differencesForSectionedView(initialSections: oldSections, finalSections: newSections)
                        switch dataSource.decideNodeTransition(dataSource, tableNode, differences) {
                        case .animated:
                            // each difference must be run in a separate 'performBatchUpdates', otherwise it crashes.
                            // this is a limitation of Diff tool
                            for difference in differences {
                                let updateBlock = {
                                    // sections must be set within updateBlock in 'performBatchUpdates'
                                    dataSource.setSections(difference.finalSections)
                                    tableNode.batchUpdates(difference, animationConfiguration: dataSource.animationConfiguration)
                                }
                                tableNode.performBatch(
                                    animated: dataSource.animationConfiguration.animated,
                                    updates: updateBlock,
                                    completion: nil
                                )
                            }
                        case .reload:
                            dataSource.setSections(newSections)
                            tableNode.reloadDataWithoutAnimations()

                            return
                        }
                    } catch {
                        rxDebugFatalError(error)
                        dataSource.setSections(newSections)
                        tableNode.reloadDataWithoutAnimations()
                    }
                } else {
                    dataSource.setSections(newSections)
                    tableNode.reloadDataWithoutAnimations()
                }
            }
        }
        .on(observedEvent)
    }
}

extension ASTableNode: HasDelegate {
    public typealias Delegate = ASTableDelegate
}

open class RxASTableDelegateProxy: DelegateProxy<ASTableNode, ASTableDelegate>, DelegateProxyType, ASTableDelegate {
    public weak private(set) var tableNode: ASTableNode?
    
    /// - parameter tableNode: Parent object for delegate proxy.
    public init(tableNode: ASTableNode) {
        self.tableNode = tableNode
        
        super.init(parentObject: tableNode, delegateProxy: RxASTableDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        register { RxASTableDelegateProxy(tableNode: $0) }
    }
    
    private var _contentOffsetBehaviorSubject: BehaviorSubject<CGPoint>?
    private var _contentOffsetPublishSubject: PublishSubject<Void>?
    
    internal var contentOffsetBehaviorSubject: BehaviorSubject<CGPoint> {
        if let subject = _contentOffsetBehaviorSubject {
            return subject
        }

        let subject = BehaviorSubject<CGPoint>(value: tableNode?.contentOffset ?? CGPoint.zero)
        _contentOffsetBehaviorSubject = subject

        return subject
    }
    
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

open class RxASTableSectionedReloadDataSource<S: SectionModelType>: ASTableSectionedDataSource<S>, RxASTableDataSourceType {
    public typealias Element = [S]
    
    open func tableNode(_ tableNode: ASTableNode, observedEvent: Event<Element>) {
        Binder(self) { dataSource, element in
            #if DEBUG
            dataSource._dataSourceBound = true
            #endif
            dataSource.setSections(element)
            tableNode.reloadData()
        }
        .on(observedEvent)
    }
}

extension ASTableNode: HasDataSource {
    public typealias DataSource = ASTableDataSource
}

private let tableDataSourceNotSet = ASTableDataSourceNotSet()

final class ASTableDataSourceNotSet: NSObject, ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        rxAbstractMethod(message: dataSourceNotSet)
    }
}

final class RxASTableDataSourceProxy: DelegateProxy<ASTableNode, ASTableDataSource>, DelegateProxyType, ASTableDataSource {
    public weak private(set) var tableNode: ASTableNode?
    
    /// - parameter tableNode: Parent object for delegate proxy.
    public init(tableNode: ASTableNode) {
        self.tableNode = tableNode
        
        super.init(parentObject: tableNode, delegateProxy: RxASTableDataSourceProxy.self)
    }
    
    // Register known implementations
    public static func registerKnownImplementations() {
        register { RxASTableDataSourceProxy(tableNode: $0) }
    }
    
    private weak var _requiredMethodsDataSource: ASTableDataSource? = tableDataSourceNotSet
    
    // MARK: DataSource
    
    public func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        (_requiredMethodsDataSource
                ?? tableDataSourceNotSet).tableNode!(tableNode, numberOfRowsInSection: section)
    }
    
    public func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        (_requiredMethodsDataSource ?? tableDataSourceNotSet).tableNode!(tableNode, nodeBlockForRowAt: indexPath)
    }
    
    public override func setForwardToDelegate(_ forwardToDelegate: ASTableDataSource?, retainDelegate: Bool) {
        _requiredMethodsDataSource = forwardToDelegate ?? tableDataSourceNotSet

        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
}

/// Marks data source as `ASTableNode` reactive data source enabling it to be used with one of the `bindTo` methods.
public protocol RxASTableDataSourceType /*: ASTableDataSource*/ {
    associatedtype Element
    
    /// New observable sequence event observed.
    ///
    /// - parameter tableView: Bound table node.
    /// - parameter observedEvent: Event
    func tableNode(_ tableNode: ASTableNode, observedEvent: Event<Element>)
}
