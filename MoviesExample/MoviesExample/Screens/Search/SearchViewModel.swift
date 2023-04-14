//
//  SearchViewModel.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

struct SearchMovieEvent: Event {
    let query: String?
}

private struct LoadTrendingEvent: Event {}

@MainActor
final class SearchViewModel: EventViewModel {
    struct DTO {
        struct DataSource {
            let getTrendingMovies: @MainActor () -> Observable<[ListMovieEntity]>
            let getSearchMovies: @MainActor (_ query: String) -> Observable<[ListMovieEntity]>
        }

        struct Navigation {
            let followMovie: @MainActor (ListMovieEntity) -> Responder?
        }

        let source: DataSource
        let navigation: Navigation
    }

    var listDataObs: Observable<[AnimatableSectionModel<SearchSectionHeaderNodeViewModel, CellViewModel>]> {
        Observable
            .combineLatest(
                trendingDataObs
                    .map(mapSearchTrendingMovies(_:))
                    .startWith([
                        AnimatableSectionModel(
                            model: SearchSectionHeaderNodeViewModel(title: R.string.localizable.search_section_trending()),
                            items: [ShimmerCellNodeViewModel(kind: .trending)]
                        ),
                    ]),
                searchDataObs
                    .skip(1)
                    .map(mapSearchMovies(_:))
            )
            .map { trending, search in
                search.isEmpty.fold { search } _: { trending }
            }
    }
    let data: DTO
    @Obs.Relay()
    var beginSearchObs: Observable<Void>

    @Obs.Relay(value: [])
    private var trendingDataObs: Observable<[ListMovieEntity]>
    @Obs.Relay(value: [])
    private var searchDataObs: Observable<[ListMovieEntity]>
    private let searchQueryRelay = PublishRelay<String?>()

    init(data: DTO) {
        self.data = data

        super.init()

        bind()
    }

    override func run(_ event: Event) {
        switch event {
        case _ as LoadTrendingEvent:
            data.source.getTrendingMovies()
                .handleLoading(isLoadingRelay)
                .catchAndReturn([])
                .bind(to: _trendingDataObs.rx)
                .disposed(by: bag)
        case let event as DidSelectEvent:
            let entity = _searchDataObs.value.isEmpty.fold { _searchDataObs.value[event.indexPath.row] } _: { _trendingDataObs.value[event.indexPath.row] }
            nextEventResponder = data.navigation.followMovie(entity)
        case _ as BecomeVisibleEvent:
            if _trendingDataObs.value.isEmpty && isNotLoading {
                perform(LoadTrendingEvent())
            }
        case let event as SearchMovieEvent:
            searchQueryRelay.accept(event.query)
        default:
            super.run(event)
        }
    }

    override func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)
        _beginSearchObs.rx.accept(())
        return true
    }

    private func bind() {
        searchQueryRelay
            .compactMap { $0 }
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.asyncInstance)
            .flatMapLatest { [data] query in
                if query.count > 1 {
                    return data.source.getSearchMovies(query)
                        .catchAndReturn([])
                } else {
                    return .just([])
                }
            }
            .bind(to: _searchDataObs.rx)
            .disposed(by: bag)
    }
}

private func mapSearchTrendingMovies(_ data: [ListMovieEntity]) -> [AnimatableSectionModel<SearchSectionHeaderNodeViewModel, CellViewModel>] {
    [
        AnimatableSectionModel(
            model: SearchSectionHeaderNodeViewModel(title: R.string.localizable.search_section_trending()),
            items: data.isEmpty ? [ShimmerCellNodeViewModel(kind: .trending)] : data.map(SearchTrendingMovieCellNodeViewModel.init(listEntity:))
        ),
    ]
}

private func mapSearchMovies(_ data: [ListMovieEntity]) -> [AnimatableSectionModel<SearchSectionHeaderNodeViewModel, CellViewModel>] {
    if data.isEmpty {
        return []
    } else {
        return [
            AnimatableSectionModel(
                model: SearchSectionHeaderNodeViewModel(title: R.string.localizable.search_section_search()),
                items: data.map(SearchTrendingMovieCellNodeViewModel.init(listEntity:))
            ),
        ]
    }
}
