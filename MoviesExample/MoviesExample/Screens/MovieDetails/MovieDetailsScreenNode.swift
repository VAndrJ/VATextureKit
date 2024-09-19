//
//  MovieDetailsScreenNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

final class MovieDetailsScreenNode: ScreenNode<MovieDetailsViewModel>, @unchecked Sendable {
    private lazy var listNode = VAMainActorWrapperNode { [viewModel] in
        VAListNode(
            context: .init(
                listDataObs: viewModel.listDataObs,
                onSelect: { [weak viewModel] in viewModel?.perform(DidSelectEvent(indexPath: $0)) },
                cellGetter: mapToCell(viewModel:)
            ),
            layoutData: .init(
                sizing: .entireWidthFreeHeight()
            )
        )
    }

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
            .subscribe(onNext: self ?> { $0.listNode.child.scrollToTop() })
            .disposed(by: bag)
        viewModel.titleObs
            .subscribe(onNext: self ?> { $0.closestViewController?.title = $1 })
            .disposed(by: bag)
    }
}
