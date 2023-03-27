//
//  VATableListNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 22.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit
import RxSwift
import RxCocoa

class VATableListNode<S: AnimatableSectionModelType>: ASTableNode, ASTableDelegate {
    public struct ElementDTO {
        var style: UITableView.Style = .plain
        let listDataObs: Observable<[S.Item]>
        let onSelect: (IndexPath) -> Void
        let cellGetter: (S.Item) -> ASCellNode
        var shouldBatchFetch: (() -> Bool)?
        var loadMore: () -> Void = {}
    }
    
    struct DTO {
        var style: UITableView.Style = .plain
        let listDataObs: Observable<[S]>
        let onSelect: (IndexPath) -> Void
        let cellGetter: (S.Item) -> ASCellNode
        var shouldBatchFetch: (() -> Bool)?
        var loadMore: () -> Void = {}
    }
    
    let data: DTO
    public private(set) var batchContext: ASBatchContext?
    
    private let bag = DisposeBag()
    
    convenience init<T>(data: ElementDTO) where S == AnimatableSectionModel<String, T> {
        self.init(data: DTO(
            style: data.style,
            listDataObs: data.listDataObs.map { [AnimatableSectionModel(model: "", items: $0)] },
            onSelect: data.onSelect,
            cellGetter: data.cellGetter,
            shouldBatchFetch: data.shouldBatchFetch,
            loadMore: data.loadMore
        ))
    }
    
    init(data: DTO) {
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
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        data.onSelect(indexPath)
        tableNode.deselectRow(at: indexPath, animated: true)
    }
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        data.shouldBatchFetch?() ?? false
    }
}
