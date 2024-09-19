//
//  MovieDetailsTrailerCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKitRx
import RxSwift
import RxCocoa

final class MovieDetailsTrailerCellNode: VACellNode, @unchecked Sendable {
    private let imageNode: VANetworkImageNode
    private let viewModel: MovieDetailsTrailerCellNodeViewModel
    private let bag = DisposeBag()
    
    init(viewModel: MovieDetailsTrailerCellNodeViewModel) {
        self.viewModel = viewModel
        self.imageNode = VANetworkImageNode(
            image: viewModel.image?.getImagePath(width: 500),
            contentMode: .scaleAspectFill,
            corner: .init(clipsToBounds: true)
        )
        .withAnimatedTransition(
            id: "image_\(viewModel.transitionId)",
            animation: .default(additions: .init(opacity: .skip))
        )

        super.init()

        bind()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode
            .ratio(230 / 375)
    }

    override func configureTheme(_ theme: VATheme) {
        imageNode.backgroundColor = theme.systemGray6
    }

    private func bind() {
        viewModel.dataObs?
            .subscribe(onNext: imageNode ?> { $0.update(image: $1?.getImagePath(width: 500)) })
            .disposed(by: bag)
    }
}

final class MovieDetailsTrailerCellNodeViewModel: CellViewModel {
    let image: String?
    let dataObs: Observable<String?>?

    override var transitionId: String { _transitionId }

    private let _transitionId: String

    init(listMovie source: ListMovieEntity, dataObs: Observable<MovieEntity?>?) {
        self.image = source.backdropPath
        self._transitionId = "\(source.id)"
        self.dataObs = dataObs?.compactMap { $0 }.map(\.backdropPath)

        super.init(identity: "\(source.id)_\(String(describing: type(of: self)))")
    }
}
