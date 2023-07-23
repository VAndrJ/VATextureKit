//
//  VAPagerNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.04.2023.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

/// ASPagerNode does not currently support circular scrolling.
/// So I added some crutches to mimic it.
/// In some cases it may not work very well, but I'll deal with that later.
open class VAPagerNode<Item: Equatable & IdentifiableType>: ASPagerNode, ASPagerDataSource, ASPagerDelegate {
    public struct ObsDTO {
        let itemsObs: Observable<[Item]>
        let cellGetter: (Item) -> ASCellNode
        let isCircular: Bool

        public init(
            itemsObs: Observable<[Item]>,
            cellGetter: @escaping (Item) -> ASCellNode,
            isCircular: Bool = false
        ) {
            self.itemsObs = itemsObs
            self.cellGetter = cellGetter
            self.isCircular = isCircular
        }
    }

    public struct DTO {
        var items: [Item]
        let cellGetter: (Item) -> ASCellNode
        let isCircular: Bool

        public init(
            items: [Item],
            cellGetter: @escaping (Item) -> ASCellNode,
            isCircular: Bool = false
        ) {
            self.items = items
            self.cellGetter = cellGetter
            self.isCircular = isCircular
        }
    }

    public var itemsCountObs: Observable<Int> { itemsCountRelay.asObservable() }
    public var itemsCount: Int { itemsCountRelay.value }
    public var indexObs: Observable<CGFloat> { indexRelay.asObservable() }
    public var itemSize: CGSize {
        var size = bounds.size
        size.height -= (contentInset.top + contentInset.bottom)
        return size
    }
    public var itemPosition: CGFloat { contentOffset.x / itemSize.width }
    public let bag = DisposeBag()
    public private(set) var data: DTO {
        didSet { itemsCountRelay.accept(data.items.count) }
    }

    private let delayedConfiguration: Bool
    private let indexRelay = BehaviorRelay<CGFloat>(value: 0)
    private let itemsCountRelay: BehaviorRelay<Int>

    public convenience init(data: ObsDTO) {
        self.init(data: .init(
            items: [],
            cellGetter: data.cellGetter,
            isCircular: data.isCircular
        ))

        data.itemsObs
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.update(items: $0)
            })
            .disposed(by: bag)
    }

    public init(data: DTO) {
        self.data = data
        self.itemsCountRelay = BehaviorRelay(value: data.items.count)
        self.delayedConfiguration = !Thread.current.isMainThread
        let flowLayout = ASPagerFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0

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

    public func scroll(to index: Int) {
        self.scroll(to: index, animated: true)
    }

    public func scroll(to index: Int, animated: Bool) {
        scrollToPage(at: index + (data.isCircular ? 1 : 0), animated: animated)
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
        reloadDataWithoutAnimations()
        checkPosition()
    }

    open func configureTheme() {
        reloadDataWithoutAnimations()
    }

    open func themeDidChanged() {
        configureTheme()
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

    @objc private func themeDidChanged(_ notification: Notification) {
        themeDidChanged()
    }

    private func configure() {
        backgroundColor = .clear
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
