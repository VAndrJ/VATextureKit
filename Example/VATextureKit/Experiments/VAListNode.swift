//
//  VAListNode.swift
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

public class VAListNode<S: AnimatableSectionModelType>: ASCollectionNode, ASCollectionDelegate {
    public struct ElementDTO {
        let listDataObs: Observable<[S.Item]>
        let onSelect: (IndexPath) -> Void
        let cellGetter: (S.Item) -> ASCellNode
        var shouldBatchFetch: (() -> Bool)?
        var loadMore: () -> Void = {}
    }
    
    public struct DTO {
        let listDataObs: Observable<[S]>
        let onSelect: (IndexPath) -> Void
        let cellGetter: (S.Item) -> ASCellNode
        var shouldBatchFetch: (() -> Bool)?
        var loadMore: () -> Void = {}
    }
    
    public struct LayoutDTO {
        var animated = true
        var scrollDirection: UICollectionView.ScrollDirection = .vertical
        var minimumLineSpacing: CGFloat = .leastNormalMagnitude
        var minimumInteritemSpacing: CGFloat = .leastNormalMagnitude
        var contentInset: UIEdgeInsets = .zero
        var sizing: CollectionNodeSizing?
        var albumSizing: CollectionNodeSizing?
    }
    
    public let data: DTO
    public let layoutData: LayoutDTO
    public private(set) var batchContext: ASBatchContext?
    
    private let bag = DisposeBag()
    private let isLoadingRelay = BehaviorRelay(value: false)
    
    public convenience init<T>(data: ElementDTO, layout: LayoutDTO) where S == AnimatableSectionModel<String, T> {
        self.init(
            data: .init(
                listDataObs: data.listDataObs.map { [AnimatableSectionModel(model: "", items: $0)] },
                onSelect: data.onSelect,
                cellGetter: data.cellGetter,
                shouldBatchFetch: data.shouldBatchFetch,
                loadMore: data.loadMore
            ),
            layout: layout
        )
    }
    
    public init(data: DTO, layout: LayoutDTO) {
        self.layoutData = layout
        self.data = data
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = layout.scrollDirection
        flowLayout.minimumLineSpacing = layout.minimumLineSpacing
        flowLayout.minimumInteritemSpacing = layout.minimumInteritemSpacing
        
        super.init(
            frame: CGRect(origin: .zero, size: CGSize(same: 320)),
            collectionViewLayout: flowLayout,
            layoutFacilitator: nil
        )
        
        contentInset = layout.contentInset
        bind()
    }
    
    private func bind() {
        let dataSource = RxASCollectionSectionedAnimatedDataSource<S> { [data] _, _, _, item in { data.cellGetter(item) } }
        data.listDataObs
            .do(onNext: { [weak self] _ in
                self?.batchContext?.completeBatchFetching(true)
                self?.batchContext = nil
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
    }
    
    // MARK: - ASCollectionDelegate
    
    public func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
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
    }
    
    public func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        data.shouldBatchFetch?() ?? false
    }
}

extension String: IdentifiableType {
    public var identity: String { self }
}
