//
//  VASlidingTabBarNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 02.05.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

open class VASlidingTabBarNode<TabData>: VAScrollNode {
    public struct Context {
        var data: [TabData]
        let spacing: CGFloat
        let contentInset: UIEdgeInsets
        let indicatorInset: CGFloat
        let color: (VATheme) -> UIColor
        let item: (_ data: TabData, _ onSelect: @escaping () -> Void) -> any ASDisplayNode & VASlidingTab
        let indexObs: Observable<CGFloat>
        let onSelect: (Int) -> Void
    }

    private var data: Context
    private var items: [(any ASDisplayNode & VASlidingTab)]
    private let bag = DisposeBag()
    private lazy var indicatorContainerNode = VASlidingIndicatorContainerNode(color: data.color)

    public init(data: Context) {
        self.data = data
        self.items = data.data.enumerated().map { index, value in
            data.item(value, { data.onSelect(index) })
        }

        super.init(data: .init(
            scrollableDirections: .horizontal,
            alwaysBounceVertical: false,
            alwaysBounceHorizontal: true
        ))
    }

    open override func didLoad() {
        super.didLoad()

        bind()
    }

    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Row(spacing: data.spacing) {
            items
        }
        .padding(.insets(data.contentInset))
        .background(indicatorContainerNode)
    }

    @MainActor
    private func scroll(index: CGFloat) {
        let currentIndex = Int(index)
        guard let currentItem = items[node: currentIndex], let nextItem = items[node: currentIndex + 1] else {
            return
        }

        let progress = index.truncatingRemainder(dividingBy: 1)
        let itemOffset = currentItem.frame.origin.x - data.contentInset.left
        let contentWidth = view.contentSize.width
        let frameOffset = itemOffset + (currentItem.frame.width + data.spacing) * progress
        let frameDelta = currentItem.frame.width - nextItem.frame.width
        let indicatorWidth = currentItem.frame.width - frameDelta * progress
        let halfProgress = (currentItem.frame.width * (1 - progress) + nextItem.frame.width * progress) / 2
        let desiredOffset = frameOffset - bounds.width / 2 + halfProgress + data.contentInset.left
        let targetOffset = max(0, min(contentWidth - bounds.width, desiredOffset))

        view.contentOffset.x = targetOffset
        let indicatorFrame = CGRect(
            origin: CGPoint(x: frameOffset + data.contentInset.left - data.indicatorInset, y: data.contentInset.top),
            size: CGSize(width: indicatorWidth + data.indicatorInset * 2, height: currentItem.frame.height)
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

        return CGRect(origin: convertedOrigin, size: intersectionFrame.size)
    }

    @MainActor
    private func bind() {
        Observable
            .combineLatest(
                rx.methodInvoked(#selector(didEnterVisibleState)),
                data.indexObs
            )
            .map { $1 }
            .subscribe(onNext: self ?>> { $0.scroll(index:) })
            .disposed(by: bag)
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
