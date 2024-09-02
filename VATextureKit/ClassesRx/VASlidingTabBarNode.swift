//
//  VASlidingTabBarNode.swift
//  VATextureKitRx
//
//  Created by Volodymyr Andriienko on 20.03.2024.
//

#if compiler(>=6.0)
public import VATextureKit
public import RxSwift
#else
import VATextureKit
import RxSwift
#endif
import RxCocoa

public protocol VASlidingTab {
    associatedtype TabData

    init(data: TabData, onSelect: @MainActor @escaping () -> Void)

    func update(intersection: CGRect)
}

open class VASlidingTabBarNode<TabData>: VAScrollNode, @unchecked Sendable {
    public struct Context {
        let data: [TabData]
        let spacing: CGFloat
        let contentInset: UIEdgeInsets
        let indicatorInset: CGFloat
        let color: (VATheme) -> UIColor
        let item: (_ data: TabData, _ onSelect: @MainActor @escaping () -> Void) -> any ASDisplayNode & VASlidingTab
        let indexObs: Observable<CGFloat>
        let onSelect: @MainActor (Int) -> Void

        public init(
            data: [TabData],
            spacing: CGFloat,
            contentInset: UIEdgeInsets,
            indicatorInset: CGFloat,
            color: @escaping (VATheme) -> UIColor,
            item: @escaping (TabData, @escaping () -> Void) -> any ASDisplayNode & VASlidingTab,
            indexObs: Observable<CGFloat>,
            onSelect: @MainActor @escaping (Int) -> Void
        ) {
            self.data = data
            self.spacing = spacing
            self.contentInset = contentInset
            self.indicatorInset = indicatorInset
            self.color = color
            self.item = item
            self.indexObs = indexObs
            self.onSelect = onSelect
        }
    }

    private var context: Context
    private var items: [any ASDisplayNode & VASlidingTab]
    private let bag = DisposeBag()
    private lazy var indicatorContainerNode = VASlidingIndicatorContainerNode(color: context.color)

    public init(context: Context) {
        self.context = context
        self.items = context.data.enumerated().map { index, value in
            context.item(value, { context.onSelect(index) })
        }

        super.init(context: .init(
            scrollableDirections: .horizontal,
            alwaysBounceVertical: false,
            alwaysBounceHorizontal: true
        ))
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Row(spacing: context.spacing) {
            items
        }
        .padding(.insets(context.contentInset))
        .background(indicatorContainerNode)
    }

    @MainActor
    private func scroll(index: CGFloat) {
        let currentIndex = Int(index)
        guard let currentItem = items[node: currentIndex], let nextItem = items[node: currentIndex + 1] else { return }

        let progress = index.truncatingRemainder(dividingBy: 1)
        let itemOffset = currentItem.frame.origin.x - context.contentInset.left
        let contentWidth = view.contentSize.width
        let frameOffset = itemOffset + (currentItem.frame.width + context.spacing) * progress
        let frameDelta = currentItem.frame.width - nextItem.frame.width
        let indicatorWidth = currentItem.frame.width - frameDelta * progress
        let halfProgress = (currentItem.frame.width * (1 - progress) + nextItem.frame.width * progress) / 2
        let desiredOffset = frameOffset - bounds.width / 2 + halfProgress + context.contentInset.left
        let targetOffset = max(0, min(contentWidth - bounds.width, desiredOffset))

        view.contentOffset.x = targetOffset
        let indicatorFrame = CGRect(
            origin: .init(x: frameOffset + context.contentInset.left - context.indicatorInset, y: context.contentInset.top),
            size: .init(width: indicatorWidth + context.indicatorInset * 2, height: currentItem.frame.height)
        )
        indicatorContainerNode.targetIndicatorFrame = indicatorFrame
        items.forEach { $0.update(intersection: .zero) }

        currentItem.update(intersection: convertIntersection(indicator: indicatorFrame, node: currentItem))
        nextItem.update(intersection: convertIntersection(indicator: indicatorFrame, node: nextItem))
    }

    @MainActor
    private func convertIntersection(indicator frame: CGRect, node: ASDisplayNode) -> CGRect {
        let intersectionFrame = node.frame.intersection(frame)
        let convertedOrigin = view.convert(intersectionFrame.origin, to: node.view)

        return .init(origin: convertedOrigin, size: intersectionFrame.size)
    }

    @MainActor
    private func bind() {
        Observable
            .combineLatest(
                rx.methodInvoked(#selector(didEnterVisibleState)),
                context.indexObs
            )
            .map { $1 }
            .subscribe(onNext: { [weak self] in self?.scroll(index: $0) })
            .disposed(by: bag)
    }
}

final class VASlidingIndicatorContainerNode: VADisplayNode, @unchecked Sendable {
    var targetIndicatorFrame: CGRect = .zero {
        didSet { setNeedsLayout() }
    }

    let indicatorNode = VADisplayNode(corner: .init(radius: .proportional(percent: 100)))

    private let color: (VATheme) -> UIColor

    init(color: @escaping (VATheme) -> UIColor) {
        self.color = color

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        indicatorNode
            .absolutely(frame: targetIndicatorFrame)
    }

    override func configureTheme(_ theme: VATheme) {
        indicatorNode.backgroundColor = color(theme)
    }
}

private extension Array {

    subscript(node index: Int) -> Element? {
        guard !isEmpty else {
            return nil
        }

        return self[Swift.max(0, Swift.min(count - 1, index))]
    }
}
