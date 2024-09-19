//
//  MovieDetailsTitleCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import VATextureKitRx
import RxSwift
import RxCocoa

final class MovieDetailsTitleCellNode: VACellNode, @unchecked Sendable {
    private static let minimumRatingToDisplay = 60.0

    private let titleTextNode: VATextNode
    private let yearTextNode: VATextNode
    private var ratingNode: RatingNode? {
        didSet { setNeedsLayout() }
    }
    private let viewModel: MovieDetailsTitleCellNodeViewModel
    private let bag = DisposeBag()

    init(viewModel: MovieDetailsTitleCellNodeViewModel) {
        self.viewModel = viewModel
        self.titleTextNode = VATextNode(text: viewModel.title, fontStyle: .headline)
            .withAnimatedTransition(id: "title_\(viewModel.transitionId)")
        self.yearTextNode = VATextNode(
            text: viewModel.year,
            maximumNumberOfLines: 1,
            colorGetter: { $0.secondaryLabel }
        )
        if viewModel.rating >= Self.minimumRatingToDisplay {
            self.ratingNode = RatingNode(rating: viewModel.rating)
        }

        super.init()

        bind()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 4, cross: .stretch) {
            Row {
                titleTextNode
                    .flex(shrink: 0.1)
            }
            Row(spacing: 4, main: .spaceBetween, cross: .center) {
                yearTextNode
                    .flex(shrink: 0.1)
                if let ratingNode {
                    ratingNode
                }
            }
        }
        .padding(.top(16), .horizontal(16), .bottom(8))
    }

    private func bind() {
        viewModel.dataObs?
            .subscribe(onNext: self ?> {
                $0.titleTextNode.text = $1.title
                $0.yearTextNode.text = $1.year
                if $1.rating >= Self.minimumRatingToDisplay {
                    $0.ratingNode = RatingNode(rating: $1.rating)
                } else {
                    $0.ratingNode = nil
                }
            })
            .disposed(by: bag)
    }
}

final class MovieDetailsTitleCellNodeViewModel: CellViewModel {
    let title: String
    let year: String
    let rating: Double
    let dataObs: Observable<(title: String, year: String, rating: Double)>?
    
    override var transitionId: String { _transitionId }

    private let _transitionId: String

    init(listMovie source: ListMovieEntity, dataObs: Observable<MovieEntity?>?) {
        self.title = source.title
        self.year = source.year
        self.rating = source.rating
        self._transitionId = "\(source.id)"
        self.dataObs = dataObs?.compactMap { $0 }.map {
            ($0.title, $0.year, $0.rating)
        }

        super.init(identity: "\(source.id)_\(String(describing: type(of: self)))")
    }
}
