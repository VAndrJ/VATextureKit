//
//  VATableListNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 22.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

class VATableListNode<T: Equatable>: ASTableNode, ASTableDelegate, ASTableDataSource {
    // TODO: - settings
    struct DTO {
        var style: UITableView.Style = .plain
        let listData: Observable<[T]>
        let onSelect: (IndexPath) -> Void
        let cellGetter: (T) -> ASCellNode
    }
    
    let data: DTO
    
    private var listDataDisposable: Disposable?
    private var listData: [T] = [] {
        didSet { batchUpdate(from: oldValue, to: listData) }
    }
    
    init(data: DTO) {
        self.data = data
        
        super.init(style: data.style)
    }
    
    override func didLoad() {
        super.didLoad()
        
        bind()
    }
    
    private func bind() {
        delegate = self
        dataSource = self
        listDataDisposable = data.listData
            .bind(to: rx.listData)
    }
    
    deinit {
        listDataDisposable?.dispose()
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        listData.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let cellData = listData[indexPath.row]
        return { [data] in
            data.cellGetter(cellData)
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        data.onSelect(indexPath)
        tableNode.deselectRow(at: indexPath, animated: true)
    }
}

import Differ

public extension ASTableNode {
    
    func batchUpdate<T: Collection>(from old: T, to new: T, completion: ((Bool) -> Void)? = nil) where T.Element: Equatable {
        performBatch(
            animated: true,
            updates: {
                let update = BatchUpdate(diff: old.extendedDiff(new))
                deleteRows(at: update.deletions, with: .none)
                insertRows(at: update.insertions, with: .none)
                update.moves.forEach { moveRow(at: $0.from, to: $0.to) }
            },
            completion: completion
        )
    }
}
