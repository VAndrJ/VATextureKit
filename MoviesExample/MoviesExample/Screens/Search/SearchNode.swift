//
//  SearchNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

final class SearchNode: DisplayNode<SearchViewModel> {
    private lazy var searchNode = SearchBarNode(beginSearchObs: viewModel.beginSearchObs)
    private lazy var listNode = MainActorEscaped { [viewModel] in
        VAListNode(
            data: .init(
                listDataObs: viewModel.listDataObs,
                onSelect: { [viewModel] in viewModel.perform(DidSelectEvent(indexPath: $0)) },
                cellGetter: mapToCell(viewModel:),
                headerGetter: { SearchSectionHeaderNode(viewModel: $0.model) }
            ),
            layoutData: .init(
                keyboardDismissMode: .interactive,
                shouldScrollToTopOnDataChange: true,
                sizing: .entireWidthFreeHeight(),
                layout: .default(parameters: .init(sectionHeadersPinToVisibleBounds: true))
            )
        ).flex(grow: 1)
    }.value

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                searchNode
                    .padding(.horizontal(8))
                listNode
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }

    @MainActor
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        animateLayoutTransition(context: context)
    }

    override func didLoad() {
        super.didLoad()

        bind()
    }

    override func viewDidLoad(in controller: UIViewController) {
        super.viewDidLoad(in: controller)
        
        bindKeyboardInset(scrollView: listNode.view, tabBarController: controller.tabBarController)
    }

    private func bind() {
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
