//
//  HomeViewModel.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx
import RxSwift
import RxCocoa
import Differentiator

private struct LoadMainEvent: Event {}

final class HomeViewModel: EventViewModel, @unchecked Sendable {
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
                model: HomeSectionHeaderNodeViewModel(title: L.home_section_trending()),
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

    override func run(_ event: any Event) async {
        switch event {
        case _ as LoadMainEvent:
            break
        default:
            await super.run(event)
        }
    }
}
