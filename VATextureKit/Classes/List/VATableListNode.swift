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
    public struct ElementDTO {
        let style: UITableView.Style
        let listDataObs: Observable<[S.Item]>
        let onSelect: ((IndexPath) -> Void)?
        let shouldDeselect: (deselectOnSelect: Bool, animated: Bool)
        let cellGetter: (S.Item) -> ASCellNode
        let sectionHeaderGetter: ((S) -> ASCellNode)?
        let sectionFooterGetter: ((S) -> ASCellNode)?
        let shouldBatchFetch: () -> Bool
        let loadMore: () -> Void
        
        public init(
            style: UITableView.Style = .plain,
            listDataObs: Observable<[S.Item]>,
            onSelect: ((IndexPath) -> Void)? = nil,
            shouldDeselect: (deselectOnSelect: Bool, animated: Bool) = (true, true),
            cellGetter: @escaping (S.Item) -> ASCellNode,
            sectionHeaderGetter: ((S) -> ASCellNode)? = nil,
            sectionFooterGetter: ((S) -> ASCellNode)? = nil,
            shouldBatchFetch: @escaping () -> Bool = { false },
            loadMore: @escaping () -> Void = {}
        ) {
            self.style = style
            self.listDataObs = listDataObs
            self.onSelect = onSelect
            self.shouldDeselect = shouldDeselect
            self.cellGetter = cellGetter
            self.sectionHeaderGetter = sectionHeaderGetter
            self.sectionFooterGetter = sectionFooterGetter
            self.shouldBatchFetch = shouldBatchFetch
            self.loadMore = loadMore
        }
    }
    
    public struct DTO {
        let style: UITableView.Style
        let listDataObs: Observable<[S]>
        let onSelect: ((IndexPath) -> Void)?
        let shouldDeselect: (deselectOnSelect: Bool, animated: Bool)
        let cellGetter: (S.Item) -> ASCellNode
        let sectionHeaderGetter: ((S) -> ASCellNode)?
        let sectionFooterGetter: ((S) -> ASCellNode)?
        let shouldBatchFetch: () -> Bool
        let loadMore: () -> Void
        
        public init(
            style: UITableView.Style = .plain,
            listDataObs: Observable<[S]>,
            onSelect: ((IndexPath) -> Void)? = nil,
            shouldDeselect: (deselectOnSelect: Bool, animated: Bool) = (true, true),
            cellGetter: @escaping (S.Item) -> ASCellNode,
            sectionHeaderGetter: ((S) -> ASCellNode)? = nil,
            sectionFooterGetter: ((S) -> ASCellNode)? = nil,
            shouldBatchFetch: @escaping () -> Bool = { false },
            loadMore: @escaping () -> Void = {}
        ) {
            self.style = style
            self.listDataObs = listDataObs
            self.onSelect = onSelect
            self.shouldDeselect = shouldDeselect
            self.cellGetter = cellGetter
            self.sectionHeaderGetter = sectionHeaderGetter
            self.sectionFooterGetter = sectionFooterGetter
            self.shouldBatchFetch = shouldBatchFetch
            self.loadMore = loadMore
        }
    }
    
    public let data: DTO
    public private(set) var batchContext: ASBatchContext?
    
    private let bag = DisposeBag()
    private weak var source: RxASTableSectionedAnimatedDataSource<S>?
    
    public convenience init<T>(data: ElementDTO) where S == AnimatableSectionModel<String, T> {
        self.init(data: DTO(
            style: data.style,
            listDataObs: data.listDataObs.map { [AnimatableSectionModel(model: "test", items: $0)] },
            onSelect: data.onSelect,
            shouldDeselect: data.shouldDeselect,
            cellGetter: data.cellGetter,
            sectionHeaderGetter: data.sectionHeaderGetter,
            sectionFooterGetter: data.sectionFooterGetter,
            shouldBatchFetch: data.shouldBatchFetch,
            loadMore: data.loadMore
        ))
    }
    
    public init(data: DTO) {
        self.data = data
        
        super.init(style: data.style)

        configure()
        bind()
    }
    
    public func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        data.shouldBatchFetch()
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let getter = data.sectionHeaderGetter, let section = source?[section] {
            return VAEmbeddableNodeView(contentNode: getter(section))
        } else {
            return nil
        }
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let getter = data.sectionFooterGetter, let section = source?[section] {
            return VAEmbeddableNodeView(contentNode: getter(section))
        } else {
            return nil
        }
    }

    private func bind() {
        let dataSource = RxASTableSectionedAnimatedDataSource<S> { [data] _, _, _, item in { data.cellGetter(item) } }
        self.source = dataSource
        data.listDataObs
            .do(onNext: { [weak self] _ in self?.batchContext?.completeBatchFetching(true) })
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
                    self?.deselectRow(at: $0, animated: data.shouldDeselect.animated)
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
        view.sectionHeaderHeight = UITableView.automaticDimension
        view.estimatedSectionHeaderHeight = .leastNormalMagnitude
        view.sectionFooterHeight = UITableView.automaticDimension
        view.estimatedSectionFooterHeight = .leastNormalMagnitude
    }
}
