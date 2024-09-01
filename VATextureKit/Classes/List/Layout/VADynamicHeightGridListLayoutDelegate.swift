//
//  VADynamicHeightGridListLayoutDelegate.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.07.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

// swiftlint:disable all
public class VADynamicHeightGridListLayoutDelegate: NSObject, ASCollectionLayoutDelegate {
    private let info: VADynamicHeightGridListLayoutInfo

    public init(info: VADynamicHeightGridListLayoutInfo) {
        self.info = info
    }

    public func scrollableDirections() -> ASScrollDirection {
        .vertical
    }

    public func additionalInfoForLayout(withElements elements: ASElementMap) -> Any? {
        info
    }

    public static func calculateLayout(with context: ASCollectionLayoutContext) -> ASCollectionLayoutState {
        guard let elements = context.elements, !elements.itemIndexPaths.isEmpty, context.viewportSize != .zero else {
            return ASCollectionLayoutState(context: context)
        }

        let info = context.additionalInfo as! VADynamicHeightGridListLayoutInfo
        let layoutWidth = context.viewportSize.width
        let numberOfSections = elements.numberOfSections
        let attrsMap = NSMapTable<ASCollectionElement, UICollectionViewLayoutAttributes>.elementToLayoutAttributes()
        var top = 0.0
        var columnHeights: [[CGFloat]] = []
        for section in 0..<numberOfSections {
            let numberOfItems = elements.numberOfItems(inSection: section)
            top += info.sectionInsets.top
            if info.headerHeight > 0 {
                let indexPath = IndexPath(item: 0, section: section)
                if let element = elements.supplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                    let attrs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
                    let sizeRange = getHeaderSizeRange(section: section, viewportSize: context.viewportSize, info: info)
                    let size = element.node.layoutThatFits(sizeRange).size
                    let frame = CGRect(x: info.sectionInsets.left, y: top, width: size.width, height: size.height)
                    attrs.frame = frame
                    attrsMap.setObject(attrs, forKey: element)
                    top = frame.maxY
                }
            }
            let columns: Int
            if context.viewportSize.width > context.viewportSize.height {
                columns = info.albumColumns ?? info.portraitColumns
            } else {
                columns = info.portraitColumns
            }
            columnHeights.append([])
            for _ in 0..<columns {
                columnHeights[section].append(top)
            }
            let columnWidth = getColumnWidth(section: section, viewportSize: context.viewportSize, info: info)
            for idx in 0..<numberOfItems {
                let columnIndex = getShortestColumnIndex(section: section, columnHeights: columnHeights)
                let indexPath = IndexPath(item: idx, section: section)
                if let element = elements.elementForItem(at: indexPath) {
                    let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    let sizeRange = getSizeRange(item: element.node, indexPath: indexPath, viewportSize: context.viewportSize, info: info)
                    let size = element.node.layoutThatFits(sizeRange).size
                    let position = CGPoint(
                        x: info.sectionInsets.left + (columnWidth + info.columnSpacing) * Double(columnIndex),
                        y: columnHeights[section][columnIndex]
                    )
                    let frame = CGRect(x: position.x, y: position.y, width: size.width, height: size.height)
                    attrs.frame = frame
                    attrsMap.setObject(attrs, forKey: element)
                    columnHeights[section][columnIndex] = frame.maxY + info.interItemSpacing
                }
            }
            let columnIndex = getTallestColumnIndex(section: section, columnHeight: columnHeights)
            top = columnHeights[section][columnIndex] - info.interItemSpacing + info.sectionInsets.bottom
            for idx in columnHeights[section].indices {
                columnHeights[section][idx] = top
            }
        }
        let contentHeight = columnHeights.last?.first ?? 0
        let contentSize = CGSize(width: layoutWidth, height: contentHeight)

        return ASCollectionLayoutState(
            context: context,
            contentSize: contentSize,
            elementToLayoutAttributesTable: attrsMap
        )
    }

    private static func getHeaderSizeRange(
        section: Int,
        viewportSize: CGSize,
        info: VADynamicHeightGridListLayoutInfo
    ) -> ASSizeRange {
        .init(
            min: .init(width: 0, height: info.headerHeight),
            max: .init(width: getWidth(section: section, viewportSize: viewportSize, info: info), height: info.headerHeight)
        )
    }

    private static func getTallestColumnIndex(section: Int, columnHeight: [[CGFloat]]) -> Int {
        var index = 0
        var tallestHeight = 0.0
        for (key, height) in columnHeight[section].enumerated() where height > tallestHeight {
            index = key
            tallestHeight = height
        }

        return index
    }

    private static func getShortestColumnIndex(section: Int, columnHeights: [[CGFloat]]) -> Int {
        var index = 0
        var shortestHeight = CGFloat.greatestFiniteMagnitude
        for (key, height) in columnHeights[section].enumerated() where height < shortestHeight {
            index = key
            shortestHeight = height
        }

        return index
    }

    private static func getSizeRange(
        item: ASCellNode,
        indexPath: IndexPath,
        viewportSize: CGSize,
        info: VADynamicHeightGridListLayoutInfo
    ) -> ASSizeRange {
        let itemWidth = getColumnWidth(section: indexPath.section, viewportSize: viewportSize, info: info)
        if info.supportedCellTypes.isEmpty || info.supportedCellTypes.contains(where: { $0 == type(of: item) }) {
            return .init(
                min: .init(width: itemWidth, height: 0),
                max: .init(width: itemWidth, height: .greatestFiniteMagnitude)
            )
        } else {
            return .init(
                min: .init(same: itemWidth),
                max: .init(same: itemWidth)
            )
        }
    }

    private static func getColumnWidth(
        section: Int,
        viewportSize: CGSize,
        info: VADynamicHeightGridListLayoutInfo
    ) -> CGFloat {
        let columns: CGFloat
        if viewportSize.width > viewportSize.height {
            columns = CGFloat(info.albumColumns ?? info.portraitColumns)
        } else {
            columns = CGFloat(info.portraitColumns)
        }

        return (getWidth(section: section, viewportSize: viewportSize, info: info) - ((columns - 1) * info.columnSpacing)) / columns
    }

    private static func getWidth(
        section: Int,
        viewportSize: CGSize,
        info: VADynamicHeightGridListLayoutInfo
    ) -> CGFloat {
        viewportSize.width - info.sectionInsets.left - info.sectionInsets.right
    }
}

public struct VADynamicHeightGridListLayoutInfo {
    let portraitColumns: Int
    let albumColumns: Int?
    let headerHeight: CGFloat
    let columnSpacing: CGFloat
    let interItemSpacing: CGFloat
    let sectionInsets: UIEdgeInsets
    let supportedCellTypes: [AnyClass]

    public init(
        portraitColumns: Int = 2,
        albumColumns: Int? = nil,
        headerHeight: CGFloat = .leastNormalMagnitude,
        columnSpacing: CGFloat = .leastNormalMagnitude,
        interItemSpacing: CGFloat = .leastNormalMagnitude,
        sectionInsets: UIEdgeInsets = .zero,
        supportedCellTypes: [AnyClass] = []
    ) {
        self.portraitColumns = portraitColumns
        self.albumColumns = albumColumns
        self.headerHeight = headerHeight
        self.columnSpacing = columnSpacing
        self.interItemSpacing = interItemSpacing
        self.sectionInsets = sectionInsets
        self.supportedCellTypes = supportedCellTypes
    }
}
