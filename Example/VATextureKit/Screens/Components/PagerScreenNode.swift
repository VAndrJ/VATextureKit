//
//  PagerScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx
import RxSwift
import RxCocoa

struct PagerControllerNavigationIdentity: DefaultNavigationIdentity {}

extension PagerScreenNode {

    convenience init() {
        self.init(viewModel: .init())
    }
}

final class PagerScreenNode: ScreenNode, @unchecked Sendable {
    private lazy var pagerNode = VAMainActorWrapperNode { [viewModel] in
        VAPagerNode(data: .init(
            itemsObs: viewModel.pagerItemsObs,
            cellGetter: mapToCell(viewModel:),
            isCircular: true
        ))
    }
    private lazy var previousButtonNode = HapticButtonNode(title: "Previous")
        .minConstrained(size: .init(same: 44))
    private lazy var nextButtonNode = HapticButtonNode(title: "Next")
        .minConstrained(size: .init(same: 44))
    private lazy var randomizeButtonNode = HapticButtonNode(title: "Randomize")
        .minConstrained(size: .init(same: 44))
    private lazy var pagerIndicatorNode = PagerIndicatorNode(pagerNode: { [pagerNode] in pagerNode.child })
    private let viewModel: PagerScreenNodeViewModel

    init(viewModel: PagerScreenNodeViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                Row(main: .spaceBetween) {
                    previousButtonNode
                    nextButtonNode
                }
                .padding(.horizontal(16))
                Stack {
                    pagerNode
                    pagerIndicatorNode
                        .relatively(horizontal: .center, vertical: .end)
                }
                .flex(grow: 1)
                randomizeButtonNode
                    .centered(.X)
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)

        backgroundColor = theme.systemBackground
    }

    override func bind() {
        previousButtonNode.onTap = self ?> { $0.pagerNode.child.previous() }
        nextButtonNode.onTap = self ?> { $0.pagerNode.child.next() }
        randomizeButtonNode.onTap = self ?>> { $0.viewModel.generateRandomPagerItems }
    }
}

final class PagerScreenNodeViewModel {
    @Obs.Relay(value: (0...2).map { PagerCardCellNodeViewModel(title: "Title \($0)", description: "Description \($0)") })
    var pagerItemsObs: Observable<[CellViewModel]>

    func generateRandomPagerItems() {
        let randomInt = Int.random(in: 0...10_000_000)
        let items = (randomInt...(randomInt + Int.random(in: 0...4))).map { PagerCardCellNodeViewModel(title: "Title \($0)", description: "Description \($0)") }
        _pagerItemsObs.rx.accept(items)
    }
}

private func mapToCell(viewModel: CellViewModel) -> ASCellNode {
    switch viewModel {
    case let viewModel as PagerCardCellNodeViewModel:
        return PagerCardCellNode(viewModel: viewModel)
    default:
        assertionFailure("Implement \(type(of: viewModel))")
        
        return ASCellNode()
    }
}
