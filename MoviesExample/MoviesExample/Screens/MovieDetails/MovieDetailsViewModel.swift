//
//  MovieDetailsViewModel.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit
import Swiftional

struct OpenListMovieDetailsEvent: Event {
    let movie: ListMovieEntity
}

struct OpenListActorDetailsEvent: Event {
    let actor: ListActorEntity
}

@MainActor
final class MovieDetailsViewModel: EventViewModel {
    struct DTO {
        struct Related {
            let listMovieEntity: ListMovieEntity
        }

        struct DataSource {
            let getMovie: @MainActor (Id<Movie>) -> Observable<MovieEntity>
            let getRecommendations: @MainActor (Id<Movie>) -> Observable<[ListMovieEntity]>
            let getMovieActors: @MainActor (Id<Movie>) -> Observable<[ListActorEntity]>
        }

        struct Navigation {
            let followMovie: @MainActor (ListMovieEntity) -> Responder?
        }

        let related: Related
        let source: DataSource
        let navigation: Navigation
    }

    var listDataObs: Observable<[CellViewModel]> {
        Observable
            .combineLatest(
                movieRelay
                    .compactMap { $0 }
                    .map { mapMovieDetails($0, viewModel: self) },
                actorsRelay
                    .skip(1)
                    .map { mapMovieActors($0, viewModel: self) },
                moviesRecommendationsRelay
                    .skip(1)
                    .map { mapRecommendationMovies($0, viewModel: self) }
            )
            .map { $0 + $1 + $2 }
            .startWith([ShimmerCellNodeViewModel(kind: .movieDetails)])
    }
    let data: DTO

    private let movieRelay = BehaviorRelay<MovieEntity?>(value: nil)
    private let actorsRelay = BehaviorRelay<[ListActorEntity]>(value: [])
    private let moviesRecommendationsRelay = BehaviorRelay<[ListMovieEntity]>(value: [])

    init(data: DTO) {
        self.data = data

        super.init()

        perform(LoadDataEvent())
    }

    override func run(_ event: Event) {
        switch event {
        case _ as DidSelectEvent:
            break
        case _ as LoadDataEvent:
            let id = data.related.listMovieEntity.id
            Observable
                .combineLatest(
                    data.source.getMovie(id),
                    data.source.getRecommendations(id),
                    data.source.getMovieActors(id)
                )
                .subscribe(onNext: { [weak self] in
                    self?.movieRelay.accept($0)
                    self?.moviesRecommendationsRelay.accept($1)
                    self?.actorsRelay.accept($2)
                }) // TODO: - on error
                .disposed(by: bag)
        case let event as OpenListMovieDetailsEvent:
            nextEventResponder = data.navigation.followMovie(event.movie)
        default:
            super.run(event)
        }
    }
}

@MainActor
private func mapMovieDetails(_ data: MovieEntity, viewModel: EventViewModel) -> [CellViewModel] {
    [
        MovieDetailsTitleCellNodeViewModel(movie: data),
        MovieDetailsTrailerCellNodeViewModel(image: data.backdropPath),
        GenresTagsCellNodeViewModel(genres: data.genres),
        MovieDetailsDescriptionCellNodeViewModel(description: data.overview),
    ]
}

@MainActor
private func mapMovieActors(_ data: [ListActorEntity], viewModel: EventViewModel) -> [CellViewModel] {
    if data.isEmpty {
        return []
    } else {
        return [
            MovieActorsCellNodeViewModel(
                title: R.string.localizable.cell_actors(),
                actors: data,
                onSelect: { viewModel.perform(OpenListActorDetailsEvent(actor: $0)) }
            ),
        ]
    }
}

@MainActor
private func mapRecommendationMovies(_ data: [ListMovieEntity], viewModel: EventViewModel) -> [CellViewModel] {
    if data.isEmpty {
        return []
    } else {
        return [
            MoviesSliderCellNodeViewModel(
                title: R.string.localizable.cell_recommendations(),
                movies: data,
                onSelect: { viewModel.perform(OpenListMovieDetailsEvent(movie: $0)) }
            ),
        ]
    }
}
