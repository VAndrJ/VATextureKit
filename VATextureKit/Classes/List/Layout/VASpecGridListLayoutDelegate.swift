//
//  VASpecGridListLayoutDelegate.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.07.2023.
//

import AsyncDisplayKit

// swiftlint:disable all
public class VASpecGridListLayoutDelegate: NSObject, ASCollectionLayoutDelegate {
    private let info: VASpecGridListLayoutInfo

    public init(info: VASpecGridListLayoutInfo) {
        self.info = info
    }

    public func scrollableDirections() -> ASScrollDirection {
        info.scrollableDirection
    }

    public func additionalInfoForLayout(withElements elements: ASElementMap) -> Any? {
        info
    }

    public static func calculateLayout(with context: ASCollectionLayoutContext) -> ASCollectionLayoutState {
        guard let elements = context.elements, !elements.itemIndexPaths.isEmpty else {
            return ASCollectionLayoutState(context: context)
        }
        let info = context.additionalInfo as! VASpecGridListLayoutInfo
        let indexPaths = elements.itemIndexPaths
        let indexMap = getIndexMap(indexPaths: indexPaths)
        let orderedIndexMap = indexMap.lazy.sorted(by: { $0.key < $1.key })
        let itemLayoutSpecs: [ASLayoutElement] = orderedIndexMap.map { section, items in
            let header = elements.supplementaryElement(
                ofKind: UICollectionView.elementKindSectionHeader,
                at: IndexPath(item: 0, section: section)
            )?.node
            let footer = elements.supplementaryElement(
                ofKind: UICollectionView.elementKindSectionFooter,
                at: IndexPath(item: 0, section: section)
            )?.node
            let itemElements = items.lazy.map { IndexPath(item: $0, section: section) }.compactMap { elements.elementForItem(at: $0) }
            let itemsSpec = getItemsSpec(
                context: context,
                section: section,
                children: Array(itemElements.map(\.node)),
                info: info
            )
            return ASStackLayoutSpec(
                direction: info.scrollableDirection == .vertical ? .vertical : .horizontal,
                spacing: 0,
                justifyContent: .start,
                alignItems: .stretch,
                children: [
                    header,
                    itemsSpec,
                    footer
                ].compactMap { $0 }
            )
        }
        let sectionLayoutSpec = getSectionLayoutSpec(context: context, children: itemLayoutSpecs, info: info)
        let layout = sectionLayoutSpec.layoutThatFits(getSizeRange(viewportSize: context.viewportSize, info: info))
        return ASCollectionLayoutState(
            context: context,
            layout: layout,
            getElementBlock: {
                ($0.layoutElement as? ASCellNode)?.value(forKey: "collectionElement") as? ASCollectionElement
            }
        )
    }

    private static func getIndexMap(indexPaths: [IndexPath]) -> [Int: [Int]] {
        var indexMap: [Int: [Int]] = [:]
        for indexPath in indexPaths {
            var items = indexMap[indexPath.section] ?? []
            items.append(indexPath.item)
            indexMap[indexPath.section] = items
        }
        return indexMap
    }

    private static func getSectionLayoutSpec(context: ASCollectionLayoutContext, children: [ASLayoutElement], info: VASpecGridListLayoutInfo) -> ASLayoutSpec {
        let spec = ASStackLayoutSpec(
            direction: info.scrollableDirection == .horizontal ? .horizontal : .vertical,
            spacing: info.sectionsConfiguration.spacing,
            justifyContent: info.sectionsConfiguration.main,
            alignItems: info.sectionsConfiguration.cross,
            children: children
        )
        if info.scrollableDirection == .horizontal {
            spec.style.preferredLayoutSize.height = .fraction(1)
        } else {
            spec.style.preferredLayoutSize.width = .fraction(1)
        }
        return spec
    }

    private static func getItemsSpec(context: ASCollectionLayoutContext, section: Int, children: [ASLayoutElement], info: VASpecGridListLayoutInfo) -> ASLayoutSpec {
        ASStackLayoutSpec(
            direction: info.scrollableDirection == .horizontal ? .vertical : .horizontal,
            spacing: info.itemsConfiguration.spacing,
            justifyContent: info.itemsConfiguration.main,
            alignItems: info.itemsConfiguration.cross,
            flexWrap: .wrap,
            alignContent: info.itemsConfiguration.alignContent,
            lineSpacing: info.itemsConfiguration.line,
            children: children
        )
    }

    private static func getSizeRange(viewportSize: CGSize, info: VASpecGridListLayoutInfo) -> ASSizeRange {
        var sizeRange = ASSizeRange.unconstrained
        if info.scrollableDirection == .horizontal {
            sizeRange.min.height = viewportSize.height
            sizeRange.max.height = viewportSize.height
        } else {
            sizeRange.min.width = viewportSize.width
            sizeRange.max.width = viewportSize.width
        }
        return sizeRange
    }
}

public struct VASpecGridListLayoutInfo {
    public struct ItemsConfiguration {
        let spacing: CGFloat
        let main: ASStackLayoutJustifyContent
        let cross: ASStackLayoutAlignItems
        let alignContent: ASStackLayoutAlignContent
        let line: CGFloat

        public init(
            spacing: CGFloat = 0,
            main: ASStackLayoutJustifyContent = .start,
            cross: ASStackLayoutAlignItems = .start,
            alignContent: ASStackLayoutAlignContent = .start,
            line: CGFloat = 0
        ) {
            self.spacing = spacing
            self.main = main
            self.cross = cross
            self.alignContent = alignContent
            self.line = line
        }
    }

    public struct SectionsConfiguration {
        let spacing: CGFloat
        let main: ASStackLayoutJustifyContent
        let cross: ASStackLayoutAlignItems

        public init(
            spacing: CGFloat = 0,
            main: ASStackLayoutJustifyContent = .start,
            cross: ASStackLayoutAlignItems = .start
        ) {
            self.spacing = spacing
            self.main = main
            self.cross = cross
        }
    }

    let scrollableDirection: ASScrollDirection
    let itemsConfiguration: ItemsConfiguration
    let sectionsConfiguration: SectionsConfiguration

    public init(
        scrollableDirection: ASScrollDirection = .vertical,
        itemsConfiguration: ItemsConfiguration = .init(),
        sectionsConfiguration: SectionsConfiguration = .init()
    ) {
        self.scrollableDirection = scrollableDirection
        self.itemsConfiguration = itemsConfiguration
        self.sectionsConfiguration = sectionsConfiguration
    }
}
