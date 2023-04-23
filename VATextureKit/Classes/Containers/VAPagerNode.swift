//
//  VAPagerNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.04.2023.
//

import AsyncDisplayKit
import RxSwift

/// ASPagerNode does not currently support circular scrolling.
/// So I added some crutches to mimic it.
/// In some cases it may not work very well, but I'll deal with that later.
open class VAPagerNode<Item: Equatable & IdentifiableType>: ASPagerNode, ASPagerDataSource, ASPagerDelegate {
    public struct DTO {
        var items: [Item]
        let cellGetter: (Item) -> ASCellNode
        let scrollDirection: UICollectionView.ScrollDirection
        let minimumLineSpacing: CGFloat
        let minimumInteritemSpacing: CGFloat
        let isCircular: Bool

        public init(
            items: [Item],
            cellGetter: @escaping (Item) -> ASCellNode,
            scrollDirection: UICollectionView.ScrollDirection = .horizontal,
            minimumLineSpacing: CGFloat = .leastNormalMagnitude,
            minimumInteritemSpacing: CGFloat = .leastNormalMagnitude,
            isCircular: Bool = false
        ) {
            self.items = items
            self.cellGetter = cellGetter
            self.scrollDirection = scrollDirection
            self.minimumLineSpacing = minimumLineSpacing
            self.minimumInteritemSpacing = minimumInteritemSpacing
            self.isCircular = isCircular
        }
    }

    public var indexObs: Observable<CGFloat> { indexRelay.asObservable() }
    public var itemSize: CGSize {
        var size = bounds.size
        size.height -= (contentInset.top + contentInset.bottom)
        return size
    }

    private var data: DTO
    private var itemPosition: CGFloat { contentOffset.x / itemSize.width }
    private let delayedConfiguration: Bool
    private let indexRelay = BehaviorRelay<CGFloat>(value: 0)

    public init(data: DTO) {
        self.data = data
        self.delayedConfiguration = !Thread.current.isMainThread
        let flowLayout = ASPagerFlowLayout()
        flowLayout.scrollDirection = data.scrollDirection
        flowLayout.minimumLineSpacing = data.minimumLineSpacing
        flowLayout.minimumInteritemSpacing = data.minimumInteritemSpacing

        super.init(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout, layoutFacilitator: nil)

        if !delayedConfiguration {
            configure()
            bind()
        }
    }

    open override func didLoad() {
        super.didLoad()

        if delayedConfiguration {
            configure()
            bind()
        }
    }

    public func next() {
        next(animated: true)
    }

    public func next(animated: Bool) {
        scrollToPage(at: currentPageIndex + 1, animated: animated)
    }

    public func previous() {
        previous(animated: true)
    }

    public func previous(animated: Bool) {
        scrollToPage(at: currentPageIndex - 1, animated: animated)
    }

    public func update(items: [Item]) {
        data.items = items
        reloadData()
        checkPosition()
    }

    private func checkPosition() {
        if data.isCircular && !data.items.isEmpty {
            DispatchQueue.main.async {
                self.scrollToPage(at: 1, animated: false)
            }
        }
    }

    private func bind() {
        setDataSource(self)
        setDelegate(self)
        checkPosition()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChanged(_:)),
            name: VAThemeManager.themeDidChangedNotification,
            object: appContext.themeManager
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChanged(_:)),
            name: VAContentSizeManager.contentSizeDidChangedNotification,
            object: appContext.contentSizeManager
        )
    }

    open func configureTheme() {
        reloadData()
    }

    open func themeDidChanged() {
        configureTheme()
    }

    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }

    private func configure() {
        backgroundColor = .clear
        shouldAnimateSizeChanges = false
    }

    private func checkIndex() {
        if data.isCircular && !data.items.isEmpty {
            switch currentPageIndex {
            case 0:
                scrollSync(index: data.items.count)
            case data.items.count + 1:
                scrollSync(index: 1)
            default:
                break
            }
        }
    }

    private func scrollSync(index: Int) {
        scrollToPage(at: index, animated: false)
        recursivelyEnsureDisplaySynchronously(true)
    }

    // MARK: - ASPagerDataSource

    public func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        data.items.count + (data.isCircular && !data.items.isEmpty ? 2 : 0)
    }

    public func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        let item: Item
        if data.isCircular {
            switch index {
            case 0:
                item = data.items[data.items.count - 1]
            case data.items.count + 1:
                item = data.items[0]
            default:
                item = data.items[index - 1]
            }
        } else {
            item = data.items[index]
        }
        return { [data] in
            data.cellGetter(item)
        }
    }

    // MARK: - ASPagerDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if data.isCircular && !data.items.isEmpty {
            indexRelay.accept(itemPosition - 1)
            switch itemPosition {
            case ...(-0.001):
                scrollSync(index: data.items.count)
            case (CGFloat(data.items.count) + 1.001)...:
                scrollSync(index: 1)
            default:
                break
            }
        } else {
            indexRelay.accept(itemPosition)
        }
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        checkIndex()
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkIndex()
    }
}
