//
//  MovieDetailsViewModel.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

struct OpenListMovieDetailsEvent: Event {
    let movie: ListMovieEntity
}

struct OpenListActorDetailsEvent: Event {
    let actor: ListActorEntity
}

final class MovieDetailsViewModel: EventViewModel {
    struct DTO {
        struct Related {
            let listMovieEntity: ListMovieEntity
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

    var titleObs: Observable<String> { movieRelay.compactMap(\.?.title) }
    @Obs.Relay()
    var scrollToTopObs: Observable<Void>
    var listDataObs: Observable<[AnimatableSectionModel<String, CellViewModel>]> {
        func getDetailsSection(items: [CellViewModel]? = nil) -> AnimatableSectionModel<String, CellViewModel> {
            AnimatableSectionModel(model: "Details", items: items ?? [ShimmerCellNodeViewModel(kind: .movieDetails)])
        }

        return Observable
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
            .map { [headerSection] in
                [
                    headerSection,
                    getDetailsSection(items: $0 + $1 + $2),
                ]
            }
            .startWith([
                headerSection,
                getDetailsSection(),
            ])
    }

    let data: DTO

    private lazy var headerSection = AnimatableSectionModel(model: "Header", items: [
        MovieDetailsTitleCellNodeViewModel(
            listMovie: data.related.listMovieEntity,
            dataObs: movieRelay.asObservable()
        ),
        MovieDetailsTrailerCellNodeViewModel(
            listMovie: data.related.listMovieEntity,
            dataObs: movieRelay.asObservable()
        ),
    ])
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
            let responder = data.navigation.followActor(event.actor)
            Task { @MainActor in
                nextEventResponder = responder
            }
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
            let responder = data.navigation.followMovie(event.movie)
            Task { @MainActor in
                nextEventResponder = responder
            }
        default:
            super.run(event)
        }
    }

    // MARK: - Responder

    override func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)
        switch event {
        case _ as ResponderOpenedFromURLEvent, _ as ResponderPoppedToExistingEvent:
            _scrollToTopObs.rx.accept(())

            return true
        default:
            return await nextEventResponder?.handle(event: event) ?? false
        }
    }
}

func mapMovieDetails(_ data: MovieEntity, viewModel: EventViewModel) -> [CellViewModel] {
    [
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
