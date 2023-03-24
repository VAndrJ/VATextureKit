//
//  VACollectionListNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit
import RxSwift
import RxCocoa

public enum CollectionNodeSizing {
    case entireWidthFreeHeight(min: CGFloat = .leastNormalMagnitude)
    case entireWidthFixedHeight(value: CGFloat)
    case entireHeightFreeWidth(min: CGFloat = .leastNormalMagnitude)
    case entireHeightFixedWidth(value: CGFloat)
    case vertical(columns: UInt, ratio: CGFloat)
    case horizontal(columns: UInt, ratio: CGFloat)
    case custom((_ collectionNode: ASCollectionNode, _ indexPath: IndexPath) -> ASSizeRange)
}

public extension ASCollectionNode {

    func cellSizeRange(sizing: CollectionNodeSizing, indexPath: IndexPath) -> ASSizeRange {
        switch sizing {
        case let .horizontal(columns, ratio):
            let spacing = ((collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0)
            let height = ((frame.height - contentInset.vertical - spacing * CGFloat(columns - 1)) / CGFloat(columns)).rounded(.down)
            return ASSizeRange(
                width: height * ratio,
                height: height
            )
        case let .vertical(columns, ratio):
            let spacing = ((collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0)
            let width = ((frame.width - contentInset.horizontal - spacing * CGFloat(columns - 1)) / CGFloat(columns)).rounded(.down)
            return ASSizeRange(
                width: width,
                height: width * ratio
            )
        case let .entireHeightFixedWidth(value):
            return ASSizeRange(
                width: value,
                height: frame.height - contentInset.vertical
            )
        case let .entireWidthFixedHeight(value):
            return ASSizeRange(
                width: frame.width - contentInset.horizontal,
                height: value
            )
        case let .entireHeightFreeWidth(min):
            return ASSizeRange(
                width: min...CGFloat.greatestFiniteMagnitude,
                height: frame.height - contentInset.vertical
            )
        case let .entireWidthFreeHeight(min):
            return ASSizeRange(
                width: frame.width - contentInset.horizontal,
                height: min...CGFloat.greatestFiniteMagnitude
            )
        case let .custom(block):
            return block(self, indexPath)
        }
    }
}

class VACollectionListNode<T: Equatable>: ASCollectionNode, ASCollectionDelegate, ASCollectionDataSource {
    // TODO: - Extend settings
    struct DTO {
        let listData: Observable<[T]>
        let onSelect: (IndexPath) -> Void
        let cellGetter: (T) -> ASCellNode
    }
    
    struct LayoutDTO {
        var scrollDirection: UICollectionView.ScrollDirection = .vertical
        var minimumLineSpacing: CGFloat = .leastNormalMagnitude
        var minimumInteritemSpacing: CGFloat = .leastNormalMagnitude
        var contentInset: UIEdgeInsets = .zero
        var sizing: CollectionNodeSizing?
        var albumSizing: CollectionNodeSizing?
    }
    
    let data: DTO
    
    private var layoutData: LayoutDTO?
    private var listDataDisposable: Disposable?
    private var listData: [T] = [] {
        didSet { batchUpdate(from: oldValue, to: listData) }
    }
    
    convenience init(data: DTO, layout: LayoutDTO) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = layout.scrollDirection
        flowLayout.minimumLineSpacing = layout.minimumLineSpacing
        flowLayout.minimumInteritemSpacing = layout.minimumInteritemSpacing
        
        self.init(data: data, collectionViewLayout: flowLayout)
        
        self.layoutData = layout
        self.contentInset = layout.contentInset
    }
    
    init(data: DTO, collectionViewLayout: UICollectionViewLayout) {
        self.data = data
        
        super.init(
            frame: CGRect(origin: .zero, size: CGSize(same: 320)),
            collectionViewLayout: collectionViewLayout,
            layoutFacilitator: nil
        )
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
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        listData.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let cellData = listData[indexPath.row]
        return { [data] in
            data.cellGetter(cellData)
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        data.onSelect(indexPath)
        collectionNode.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        if let layoutData {
            if let albumSizing = layoutData.albumSizing {
                return collectionNode.cellSizeRange(
                    sizing: (UIApplication.shared.isAlbum ? albumSizing : layoutData.sizing) ?? collectionNode.isHorizontal.fold { .entireWidthFreeHeight() } _: { .entireHeightFreeWidth() },
                    indexPath: indexPath
                )
            } else {
                return collectionNode.cellSizeRange(
                    sizing: layoutData.sizing ?? collectionNode.isHorizontal.fold { .entireWidthFreeHeight() } _: { .entireHeightFreeWidth() },
                    indexPath: indexPath
                )
            }
        } else {
            return collectionNode.cellSizeRange(
                sizing: collectionNode.isHorizontal.fold { .entireWidthFreeHeight() } _: { .entireHeightFreeWidth() },
                indexPath: indexPath
            )
        }
    }
}

import Differ

public extension ASCollectionNode {
    
    func batchUpdate<T: Collection>(from old: T, to new: T, animated: Bool = true, completion: ((Bool) -> Void)? = nil) where T.Element: Equatable {
        performBatch(
            animated: animated,
            updates: {
                let update = BatchUpdate(diff: old.extendedDiff(new))
                deleteItems(at: update.deletions)
                insertItems(at: update.insertions)
                update.moves.forEach { moveItem(at: $0.from, to: $0.to) }
            },
            completion: completion
        )
    }
}
