//
//  SearchScreenNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

final class SearchScreenNode: ScreenNode<SearchViewModel> {
    private lazy var searchNode = SearchBarNode(beginSearchObs: viewModel.beginSearchObs)
    private lazy var listNode = VAListNode(
        context: .init(
            listDataObs: viewModel.listDataObs,
            onSelect: viewModel ?> { $0.perform(DidSelectEvent(indexPath: $1)) },
            cellGetter: mapToCell(viewModel:),
            headerGetter: { SearchSectionHeaderNode(viewModel: $0.model) }
        ),
        layoutData: .init(
            keyboardDismissMode: .interactive,
            shouldScrollToTopOnDataChange: true,
            sizing: .entireWidthFreeHeight(),
            layout: .default(parameters: .init(sectionHeadersPinToVisibleBounds: true))
        )
    )

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                searchNode
                    .padding(.horizontal(8))
                listNode
                    .flex(grow: 1)
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }

    override func animateLayoutTransition(_ context: any ASContextTransitioning) {
        animateLayoutTransition(context: context)
    }

    override func viewDidLoad(in controller: UIViewController) {
        super.viewDidLoad(in: controller)
        
        bindKeyboardInset(scrollView: listNode.view, tabBarController: controller.tabBarController)
    }

    override func bind() {
        Observable
            .merge(
                rx.methodInvoked(#selector(didEnterVisibleState))
                    .map { _ in BecomeVisibleEvent() },
                searchNode.textObs
                    .distinctUntilChanged()
                    .map { SearchMovieEvent(query: $0) }
            )
            .bind(to: viewModel.eventRelay)
            .disposed(by: bag)
    }
}
