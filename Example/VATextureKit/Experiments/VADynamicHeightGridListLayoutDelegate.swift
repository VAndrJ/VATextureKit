//
//  VADynamicHeightGridListLayoutDelegate.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 22.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit

// swiftlint:disable all
class VADynamicHeightGridListLayoutDelegate: NSObject, ASCollectionLayoutDelegate {
    private let info: VADynamicHeightGridListLayoutInfo

    init(info: VADynamicHeightGridListLayoutInfo) {
        self.info = info
    }

    func scrollableDirections() -> ASScrollDirection {
        ASScrollDirectionVerticalDirections
    }

    func additionalInfoForLayout(withElements elements: ASElementMap) -> Any? {
        info
    }

    static func calculateLayout(with context: ASCollectionLayoutContext) -> ASCollectionLayoutState {
        let info = context.additionalInfo as! VADynamicHeightGridListLayoutInfo
        let layoutWidth = context.viewportSize.width
        let elements = context.elements ?? ASElementMap()
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
                    let sizeRange = _getHeaderSizeRange(section: section, viewportSize: context.viewportSize, info: info)
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
            let columnWidth = _getColumnWidth(section: section, viewportSize: context.viewportSize, info: info)
            for idx in 0..<numberOfItems {
                let columnIndex = _getShortestColumnIndex(section: section, columnHeights: columnHeights)
                let indexPath = IndexPath(item: idx, section: section)
                if let element = elements.elementForItem(at: indexPath) {
                    let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    let sizeRange = _getSizeRange(item: element.node, indexPath: indexPath, viewportSize: context.viewportSize, info: info)
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
            let columnIndex = _getTallestColumnIndex(section: section, columnHeight: columnHeights)
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

    private static func _getHeaderSizeRange(section: Int, viewportSize: CGSize, info: VADynamicHeightGridListLayoutInfo) -> ASSizeRange {
        ASSizeRange(
            min: CGSize(width: 0, height: info.headerHeight),
            max: CGSize(width: _getWidth(section: section, viewportSize: viewportSize, info: info), height: info.headerHeight)
        )
    }

    private static func _getTallestColumnIndex(section: Int, columnHeight: [[CGFloat]]) -> Int {
        var index = 0
        var tallestHeight = 0.0
        for (key, height) in columnHeight[section].enumerated() where height > tallestHeight {
            index = key
            tallestHeight = height
        }
        return index
    }

    private static func _getShortestColumnIndex(section: Int, columnHeights: [[CGFloat]]) -> Int {
        var index = 0
        var shortestHeight = CGFloat.greatestFiniteMagnitude
        for (key, height) in columnHeights[section].enumerated() where height < shortestHeight {
            index = key
            shortestHeight = height
        }
        return index
    }

    private static func _getSizeRange(item: ASCellNode, indexPath: IndexPath, viewportSize: CGSize, info: VADynamicHeightGridListLayoutInfo) -> ASSizeRange {
        let itemWidth = _getColumnWidth(section: indexPath.section, viewportSize: viewportSize, info: info)
        if info.supportedCellTypes.isEmpty || info.supportedCellTypes.contains(where: { $0 == type(of: item) }) {
            return ASSizeRange(
                min: CGSize(width: itemWidth, height: 0),
                max: CGSize(width: itemWidth, height: .greatestFiniteMagnitude)
            )
        } else {
            return ASSizeRange(
                min: CGSize(same: itemWidth),
                max: CGSize(same: itemWidth)
            )
        }
    }

    private static func _getColumnWidth(section: Int, viewportSize: CGSize, info: VADynamicHeightGridListLayoutInfo) -> CGFloat {
        let columns: CGFloat
        if viewportSize.width > viewportSize.height {
            columns = CGFloat(info.albumColumns ?? info.portraitColumns)
        } else {
            columns = CGFloat(info.portraitColumns)
        }
        return (_getWidth(section: section, viewportSize: viewportSize, info: info) - ((columns - 1) * info.columnSpacing)) / columns
    }

    private static func _getWidth(section: Int, viewportSize: CGSize, info: VADynamicHeightGridListLayoutInfo) -> CGFloat {
        viewportSize.width - info.sectionInsets.left - info.sectionInsets.right
    }
}

struct VADynamicHeightGridListLayoutInfo {
    var portraitColumns = 2
    var albumColumns: Int?
    var headerHeight = CGFloat.leastNormalMagnitude
    var columnSpacing = CGFloat.leastNormalMagnitude
    var interItemSpacing = CGFloat.leastNormalMagnitude
    var sectionInsets = UIEdgeInsets.zero
    var supportedCellTypes: [AnyClass] = []
}
