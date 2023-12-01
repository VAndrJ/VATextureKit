//
//  MovieDetailsViewModel.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx
import Swiftional

struct OpenListMovieDetailsEvent: Event {
    let movie: ListMovieEntity
}

struct OpenListActorDetailsEvent: Event {
    let actor: ListActorEntity
}

final class MovieDetailsViewModel: EventViewModel {
    struct DTO {
        struct Related {
            let id: Id<Movie>
            let listMovieEntity: ListMovieEntity?
        }

        struct DataSource {
            let getMovie: (Id<Movie>) -> Observable<MovieEntity>
            let getRecommendations: (Id<Movie>) -> Observable<[ListMovieEntity]>
            let getMovieActors: (Id<Movie>) -> Observable<[ListActorEntity]>
        }

        struct Navigation {
            let followMovie: (ListMovieEntity) -> Responder?
            let followActor: (ListActorEntity) -> Responder?
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
            .startWith([
                MovieDetailsTitleCellNodeViewModel(id: data.related.id, listMovie: data.related.listMovieEntity),
                MovieDetailsTrailerCellNodeViewModel(id: data.related.id, listMovie: data.related.listMovieEntity),
                ShimmerCellNodeViewModel(kind: .movieDetails),
            ])
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
        case let event as OpenListActorDetailsEvent:
            nextEventResponder = data.navigation.followActor(event.actor)
        case _ as DidSelectEvent:
            break
        case _ as LoadDataEvent:
            let id = data.related.id
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

func mapMovieDetails(_ data: MovieEntity, viewModel: EventViewModel) -> [CellViewModel] {
    [
        MovieDetailsTitleCellNodeViewModel(movie: data),
        MovieDetailsTrailerCellNodeViewModel(movie: data),
        GenresTagsCellNodeViewModel(genres: data.genres),
        MovieDetailsDescriptionCellNodeViewModel(description: data.overview),
    ]
}

func mapMovieActors(_ data: [ListActorEntity], viewModel: EventViewModel) -> [CellViewModel] {
    if data.isEmpty {
        return []
    } else {
        return [
            MovieActorsCellNodeViewModel(
                title: R.string.localizable.cell_actors(),
                actors: data,
                onSelect: viewModel ?> { $0.perform(OpenListActorDetailsEvent(actor: $1)) }
            ),
        ]
    }
}

func mapRecommendationMovies(_ data: [ListMovieEntity], viewModel: EventViewModel) -> [CellViewModel] {
    if data.isEmpty {
        return []
    } else {
        return [
            MoviesSliderCellNodeViewModel(
                title: R.string.localizable.cell_recommendations(),
                movies: data,
                onSelect: viewModel ?> { $0.perform(OpenListMovieDetailsEvent(movie: $1)) }
            ),
        ]
    }
}
