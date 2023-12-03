//
//  MovieDetailsNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

final class MovieDetailsNode: DisplayNode<MovieDetailsViewModel> {
    private lazy var listNode = VAListNode(
        data: .init(
            listDataObs: viewModel.listDataObs,
            onSelect: { [viewModel] in viewModel.perform(DidSelectEvent(indexPath: $0)) },
            cellGetter: mapToCell(viewModel:)
        ),
        layoutData: .init(
            sizing: .entireWidthFreeHeight()
        )
    )

    override init(viewModel: MovieDetailsViewModel) {
        super.init(viewModel: viewModel)

        bind()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            listNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }

    private func bind() {
        viewModel.scrollToTopObs
            .subscribe(onNext: listNode ?> { $0.scrollToTop() })
            .disposed(by: bag)
        viewModel.titleObs
            .subscribe(onNext: self ?> { $0.closestViewController?.title = $1 })
            .disposed(by: bag)
    }
}
