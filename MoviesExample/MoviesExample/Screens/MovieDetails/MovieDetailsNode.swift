//
//  MovieDetailsNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

final class MovieDetailsNode: DisplayNode<MovieDetailsViewModel> {
    private lazy var listNode = MainActorEscaped(value: { [viewModel] in
        VAListNode(
            data: .init(
                listDataObs: viewModel.listDataObs,
                onSelect: { [viewModel] in viewModel.perform(DidSelectEvent(indexPath: $0)) },
                cellGetter: mapToCell(viewModel:)
            ),
            layoutData: .init(
                sizing: .entireWidthFreeHeight()
            )
        )
    }).value

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
            .subscribe(onNext: self ?>> { $0.scrollToTop })
            .disposed(by: bag)
        viewModel.titleObs
            .subscribe(onNext: self ?>> { $0.updateClosestController(title:) })
            .disposed(by: bag)
    }

    private func scrollToTop() {
        Task { @MainActor in
            listNode.scrollToTop()
        }
    }

    private func updateClosestController(title: String) {
        Task { @MainActor in
            closestViewController?.title = title
        }
    }
}
