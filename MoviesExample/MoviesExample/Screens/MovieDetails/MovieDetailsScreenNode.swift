//
//  MovieDetailsScreenNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

final class MovieDetailsScreenNode: ScreenNode<MovieDetailsViewModel> {
    private lazy var listNode = VAListNode(
        data: .init(
            listDataObs: viewModel.listDataObs,
            onSelect: viewModel ?> { $0.perform(DidSelectEvent(indexPath: $1)) },
            cellGetter: mapToCell(viewModel:)
        ),
        layoutData: .init(
            sizing: .entireWidthFreeHeight()
        )
    )

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            listNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }

    override func bind() {
        viewModel.scrollToTopObs
            .subscribe(onNext: self ?> { $0.listNode.scrollToTop() })
            .disposed(by: bag)
        viewModel.titleObs
            .subscribe(onNext: self ?> { $0.closestViewController?.title = $1 })
            .disposed(by: bag)
    }
}
