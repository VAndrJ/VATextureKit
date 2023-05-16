//
//  SearchNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit
import Swiftional

@MainActor
final class SearchNode: DisplayNode<SearchViewModel> {
    private lazy var searchNode = SearchBarNode(beginSearchObs: viewModel.beginSearchObs)
    private lazy var listNode = VATableListNode(data: .init(
        configuration: .init(
            keyboardDismissMode: .interactive,
            separatorConfiguration: .init(style: .none),
            shouldScrollToTopOnDataChange: true
        ),
        listDataObs: viewModel.listDataObs,
        onSelect: { [viewModel] in viewModel.perform(DidSelectEvent(indexPath: $0)) },
        cellGetter: mapToCell(viewModel:),
        sectionHeaderGetter: SearchSectionHeaderNode.init(viewModel:)
    )).flex(grow: 1)

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
