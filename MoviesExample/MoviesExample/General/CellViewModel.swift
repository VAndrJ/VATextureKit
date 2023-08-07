//
//  CellViewModel.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

class CellViewModel: Equatable, IdentifiableType {
    static func == (lhs: CellViewModel, rhs: CellViewModel) -> Bool {
        lhs.identity == rhs.identity
    }

    var transitionId: String { identity.components(separatedBy: "_").first ?? "" }
    var identity: String

    init() {
        self.identity = UUID().uuidString
    }

    init(identity: String) {
        self.identity = identity
    }

    init(identity: Int) {
        self.identity = "\(identity)"
    }

    init<T: CustomStringConvertible>(identity: T) {
        self.identity = identity.description
    }
}

func mapToCell(viewModel: CellViewModel) -> ASCellNode {
    switch viewModel {
    case let viewModel as SearchTrendingMovieCellNodeViewModel:
        return SearchTrendingMovieCellNode(viewModel: viewModel)
    case let viewModel as ShimmerCellNodeViewModel:
        return ShimmerCellNode(viewModel: viewModel)
    case let viewModel as MoviesSliderCellNodeViewModel:
        return MoviesSliderCellNode(viewModel: viewModel)
    case let viewModel as MovieDetailsTitleCellNodeViewModel:
        return MovieDetailsTitleCellNode(viewModel: viewModel)
    case let viewModel as MovieDetailsTrailerCellNodeViewModel:
        return MovieDetailsTrailerCellNode(viewModel: viewModel)
    case let viewModel as GenresTagsCellNodeViewModel:
        return GenresTagsCellNode(viewModel: viewModel)
    case let viewModel as MovieDetailsDescriptionCellNodeViewModel:
        return MovieDetailsDescriptionCellNode(viewModel: viewModel)
    case let viewModel as MovieActorsCellNodeViewModel:
        return ActorsSliderCellNode(viewModel: viewModel)
    case let viewModel as SearchMovieCellNodeViewModel:
        return SearchMovieCellNode(viewModel: viewModel)
    case let viewModel as HomeCellNodeViewModel:
        return HomeCellNode(viewModel: viewModel)
    default:
        assertionFailure("Implement for \(type(of: viewModel))")
        return ASCellNode()
    }
}
