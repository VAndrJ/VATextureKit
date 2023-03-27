//
//  VATableListNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 27.03.2023.
//

import AsyncDisplayKit
import VATextureKit
import RxSwift
import RxCocoa

open class VATableListNode<S: AnimatableSectionModelType>: ASTableNode, ASTableDelegate {
    public struct ElementDTO {
        let style: UITableView.Style
        let listDataObs: Observable<[S.Item]>
        let onSelect: ((IndexPath) -> Void)?
        let cellGetter: (S.Item) -> ASCellNode
        let shouldBatchFetch: (() -> Bool)?
        let loadMore: () -> Void
        
        public init(
            style: UITableView.Style = .plain,
            listDataObs: Observable<[S.Item]>,
            onSelect: ((IndexPath) -> Void)? = nil,
            cellGetter: @escaping (S.Item) -> ASCellNode,
            shouldBatchFetch: (() -> Bool)? = nil,
            loadMore: @escaping () -> Void = {}
        ) {
            self.style = style
            self.listDataObs = listDataObs
            self.onSelect = onSelect
            self.cellGetter = cellGetter
            self.shouldBatchFetch = shouldBatchFetch
            self.loadMore = loadMore
        }
    }
    
    public struct DTO {
        let style: UITableView.Style
        let listDataObs: Observable<[S]>
        let onSelect: ((IndexPath) -> Void)?
        let cellGetter: (S.Item) -> ASCellNode
        let shouldBatchFetch: (() -> Bool)?
        let loadMore: () -> Void
        
        public init(
            style: UITableView.Style = .plain,
            listDataObs: Observable<[S]>,
            onSelect: ((IndexPath) -> Void)? = nil,
            cellGetter: @escaping (S.Item) -> ASCellNode,
            shouldBatchFetch: (() -> Bool)? = nil,
            loadMore: @escaping () -> Void = {}
        ) {
            self.style = style
            self.listDataObs = listDataObs
            self.onSelect = onSelect
            self.cellGetter = cellGetter
            self.shouldBatchFetch = shouldBatchFetch
            self.loadMore = loadMore
        }
    }
    
    public let data: DTO
    public private(set) var batchContext: ASBatchContext?
    
    private let bag = DisposeBag()
    
    public convenience init<T>(data: ElementDTO) where S == AnimatableSectionModel<String, T> {
        self.init(data: DTO(
            style: data.style,
            listDataObs: data.listDataObs.map { [AnimatableSectionModel(model: "", items: $0)] },
            onSelect: data.onSelect,
            cellGetter: data.cellGetter,
            shouldBatchFetch: data.shouldBatchFetch,
            loadMore: data.loadMore
        ))
    }
    
    public init(data: DTO) {
        self.data = data
        
        super.init(style: data.style)
        
        bind()
    }
    
    private func bind() {
        let dataSource = RxASTableSectionedAnimatedDataSource<S> { [data] _, _, _, item in { data.cellGetter(item) } }
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
        if let onSelect = data.onSelect {
            rx.itemSelected
                .subscribe(onNext: onSelect)
                .disposed(by: bag)
        }
    }
    
    public func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        data.shouldBatchFetch?() ?? false
    }
}
