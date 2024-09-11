//
//  SpecBasedGridListScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx
import RxSwift
import RxCocoa

struct SpecBasedGridListNavigationIdentity: DefaultNavigationIdentity {}

final class SpecBasedGridListScreenNode: ScreenNode, @unchecked Sendable {
    private lazy var listNode = VAMainActorWrapperNode { [listDataObs] in
        VAListNode(
            data: .init(
                listDataObs: listDataObs,
                cellGetter: { TagCellNode(viewModel: $0) }
            ),
            layoutData: .init(
                contentInset: .init(all: 16),
                layout: .delegate(VASpecGridListLayoutDelegate(info: .init(
                    scrollableDirection: .vertical,
                    itemsConfiguration: .init(
                        spacing: 8,
                        main: .center,
                        alignContent: .center,
                        line: 8
                    ),
                    sectionsConfiguration: .init(cross: .stretch)
                )))
            )
        )
    }

    @Obs.Relay(value: [])
    private var listDataObs: Observable<[TagCellNodeViewModel]>

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            listNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        listNode.backgroundColor = theme.systemBackground
    }

    override func bind() {
        Observable<Int>
            .timer(.seconds(0), period: .milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: self ?> {
                let newValue = $0._listDataObs.rx.value + CollectionOfOne(TagCellNodeViewModel(title: "\(Int.random(in: 0...1000))"))
                $0._listDataObs.rx.accept(newValue)
            })
            .disposed(by: bag)
    }
}
