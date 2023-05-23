//
//  MainViewModel.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

private struct LoadMainEvent: Event {}

final class MainViewModel: EventViewModel {
    struct DTO {
        struct DataSource {
        }

        struct Navigation {
        }

        let source: DataSource
        let navigation: Navigation
    }

    var listDataObs: Observable<[AnimatableSectionModel<MainSectionHeaderNodeViewModel, CellViewModel>]> {
        .just([
            AnimatableSectionModel(
                model: MainSectionHeaderNodeViewModel(title: R.string.localizable.home_section_trending()),
                items: [ShimmerCellNodeViewModel(kind: .homeCell)]
            ),
        ])
    }
    let data: DTO

    @Obs.Relay(value: nil)
    var trendingObs: Observable<[ListMovieEntity]?>

    init(data: DTO) {
        self.data = data

        super.init()

        perform(LoadMainEvent())
    }

    override func run(_ event: Event) {
        switch event {
        case _ as LoadMainEvent:
            break
        default:
            super.run(event)
        }
    }
}
