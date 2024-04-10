//
//  SearchViewModel.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

struct SearchMovieEvent: Event {
    let query: String?
}

private struct LoadTrendingEvent: Event {}

final class SearchViewModel: EventViewModel {
    struct Context {
        struct DataSource {
            let getTrendingMovies: () -> Observable<[ListMovieEntity]>
            let getSearchMovies: (_ query: String) -> Observable<[ListMovieEntity]>
        }

        struct Navigation {
            let followMovie: (ListMovieEntity) -> Void
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
    let context: Context
    @Obs.Relay()
    var beginSearchObs: Observable<Void>

    @Obs.Relay(value: [])
    private var trendingDataObs: Observable<[ListMovieEntity]>
    @Obs.Relay(value: [])
    private var searchDataObs: Observable<[ListMovieEntity]>
    private let searchQueryRelay = PublishRelay<String?>()

    init(context: Context) {
        self.context = context

        super.init()
    }

    override func run(_ event: Event) async {
        switch event {
        case _ as LoadTrendingEvent:
            context.source.getTrendingMovies()
                .handleLoading(isLoadingRelay)
                .catchAndReturn([])
                .bind(to: _trendingDataObs.rx)
                .disposed(by: bag)
        case let event as DidSelectEvent:
            let entity = _searchDataObs.value.isEmpty.fold { _searchDataObs.value[event.indexPath.row] } _: { _trendingDataObs.value[event.indexPath.row] }
            context.navigation.followMovie(entity)
        case _ as BecomeVisibleEvent:
            if _trendingDataObs.value.isEmpty && isNotLoading {
                perform(LoadTrendingEvent())
            }
        case let event as SearchMovieEvent:
            searchQueryRelay.accept(event.query)
        default:
            await super.run(event)
        }
    }

    override func bind() {
        searchQueryRelay
            .compactMap { $0 }
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.asyncInstance)
            .flatMapLatest { [context] query in
                if query.count > 1 {
                    return context.source.getSearchMovies(query)
                        .catchAndReturn([])
                } else {
                    return .just([])
                }
            }
            .bind(to: _searchDataObs.rx)
            .disposed(by: bag)
    }

    // MARK: - Responder

    override func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)
        switch event {
        case _ as ResponderOpenedFromShortcutEvent:
            mainAsync(after: .milliseconds(400)) { [weak self] in
                self?._beginSearchObs.rx.accept(())
            }
            
            return true
        default:
            return await nextEventResponder?.handle(event: event) ?? false
        }
    }
}

private func mapSearchTrendingMovies(_ data: [ListMovieEntity]) -> [AnimatableSectionModel<SearchSectionHeaderNodeViewModel, CellViewModel>] {
    return [
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
                items: data.map(SearchMovieCellNodeViewModel.init(listEntity:))
            ),
        ]
    }
}
