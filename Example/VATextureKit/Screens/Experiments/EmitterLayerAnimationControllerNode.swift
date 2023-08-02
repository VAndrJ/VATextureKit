//
//  EmitterLayerAnimationControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 01.08.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class EmitterLayerAnimationControllerNode: VASafeAreaDisplayNode {
//    private lazy var fireworksEmitterNode = VAFireworksEmitterNode(data: .init())
//    private lazy var confetti1EmitterNode = VAConfettiEmitterNode(data: .init(startPoint: .topCenter))
//    private lazy var confetti2EmitterNode = VAConfettiEmitterNode(data: .init(startPoint: .bottomLeft))
//    private lazy var confetti3EmitterNode = VAConfettiEmitterNode(data: .init(startPoint: .bottomRight))
//    private lazy var confetti4EmitterNode = VAConfettiEmitterNode(data: .init(startPoint: .center))
//    private lazy var multipleConfettiNode = VAMultipleConfettiNode()
//    private lazy var scrollNode = VAScrollNode(data: .init())
    private lazy var listNode = VAListNode(
        data: .init(
            listDataObs: Observable<[String]>.just(["0", "1", "2", "3", "4", "5"]),
            cellGetter: { value in
                switch value {
                case "1": return VAContainerCellNode(childNode: VAConfettiEmitterNode(data: .init(startPoint: .topCenter)))
                case "2": return VAContainerCellNode(childNode: VAConfettiEmitterNode(data: .init(startPoint: .bottomLeft)))
                case "3": return VAContainerCellNode(childNode: VAConfettiEmitterNode(data: .init(startPoint: .bottomRight)))
                case "4": return VAContainerCellNode(childNode: VAConfettiEmitterNode(data: .init(startPoint: .center)))
                case "5": return VAContainerCellNode(childNode: VAMultipleConfettiNode())
                default: return VAContainerCellNode(childNode: VAFireworksEmitterNode(data: .init()))
                }
            }
        ),
        layoutData: .init(
            sizing: .custom { collectionNode, _ in
                ASSizeRange(width: collectionNode.frame.width, height: collectionNode.frame.height * 3 / 4)
            },
            layout: .default(parameters: .init())
        )
    )

//    override init() {
//        super.init()
//
//        scrollNode.layoutSpecBlock = { [weak self] in
//            self?.scrollLayoutSpecThatFits($1) ?? ASLayoutSpec()
//        }
//    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        SafeArea {
            listNode
            .wrapped()
//        }
    }

//    func scrollLayoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        Column(cross: .stretch) {
//            fireworksEmitterNode
//                .ratio(1)
//            confetti1EmitterNode
//                .ratio(1)
//            confetti2EmitterNode
//                .ratio(1)
//            confetti3EmitterNode
//                .ratio(1)
//            confetti4EmitterNode
//                .ratio(1)
//            multipleConfettiNode
//                .ratio(1)
//        }
//    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}
