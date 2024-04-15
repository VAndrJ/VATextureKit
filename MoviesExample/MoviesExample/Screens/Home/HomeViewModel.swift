//
//  HomeViewModel.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

private struct LoadMainEvent: Event {}

final class HomeViewModel: EventViewModel {
    struct Context {
        struct DataSource {
        }

        struct Navigation {
        }

        let source: DataSource
        let navigation: Navigation
    }

    var listDataObs: Observable<[AnimatableSectionModel<HomeSectionHeaderNodeViewModel, CellViewModel>]> {
        .just([
            AnimatableSectionModel(
                model: HomeSectionHeaderNodeViewModel(title: R.string.localizable.home_section_trending()),
                items: [ShimmerCellNodeViewModel(kind: .homeCell)]
            ),
        ])
    }
    let context: Context

    @Obs.Relay(value: nil)
    var trendingObs: Observable<[ListMovieEntity]?>

    init(context: Context) {
        self.context = context

        super.init()

        perform(LoadMainEvent())
    }

    override func run(_ event: Event) async {
        switch event {
        case _ as LoadMainEvent:
            break
        default:
            await super.run(event)
        }
    }
}
