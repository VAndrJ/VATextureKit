//
//  VAPagerNode.swift
//  VATextureKitRx
//
//  Created by Volodymyr Andriienko on 23.04.2023.
//

import AsyncDisplayKit
import VATextureKit
import RxSwift
import RxCocoa

/// ASPagerNode does not currently support circular scrolling.
/// So I added some crutches to mimic it.
/// In some cases it may not work very well, but I'll deal with that later.
open class VAPagerNode<Item: Equatable & IdentifiableType>: ASPagerNode, ASPagerDataSource, ASPagerDelegate, VAThemeObserver, VAContentSizeObserver {
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

    public struct Context {
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

    /// The currently active theme obtained from the app's context.
    public var theme: VATheme { appContext.themeManager.theme }
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
    public private(set) var data: Context {
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

    public init(data: Context) {
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

    @MainActor
    open override func didLoad() {
        super.didLoad()

        if delayedConfiguration {
            configure()
            bind()
        }
    }

    @MainActor
    public func scroll(to index: Int) {
        self.scroll(to: index, animated: true)
    }

    @MainActor
    public func scroll(to index: Int, animated: Bool) {
        scrollToPage(at: index + (data.isCircular ? 1 : 0), animated: animated)
    }

    @MainActor
    public func next() {
        next(animated: true)
    }

    @MainActor
    public func next(animated: Bool) {
        scrollToPage(at: currentPageIndex + 1, animated: animated)
    }

    @MainActor
    public func previous() {
        previous(animated: true)
    }

    @MainActor
    public func previous(animated: Bool) {
        scrollToPage(at: currentPageIndex - 1, animated: animated)
    }

    public func update(items: [Item]) {
        data.items = items
        reloadDataWithoutAnimations()
        checkPosition()
    }

    private func checkPosition() {
        if data.isCircular && !data.items.isEmpty {
            mainAsync {
                self.scrollToPage(at: 1, animated: false)
            }
        }
    }

    private func bind() {
        setDataSource(self)
        setDelegate(self)
        checkPosition()
        configureTheme(theme)
        appContext.themeManager.addThemeObserver(self)
        appContext.contentSizeManager.addContentSizeObserver(self)
    }

    @objc open func configureTheme(_ theme: VATheme) {
        reloadDataWithoutAnimations()
    }

    public func themeDidChanged(to newValue: VATheme) {
        configureTheme(newValue)
    }

    @objc open func configureContentSize(_ contentSize: UIContentSizeCategory) {}

    public func contentSizeDidChanged(to newValue: UIContentSizeCategory) {
        configureContentSize(newValue)
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

    deinit {
        appContext.themeManager.removeThemeObserver(self)
        appContext.contentSizeManager.removeContentSizeObserver(self)
    }
}
