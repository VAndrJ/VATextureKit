//
//  SearchScreenNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx
import RxSwift
import RxCocoa

final class SearchScreenNode: ScreenNode<SearchViewModel>, @unchecked Sendable {
    private lazy var searchNode = SearchBarNode(beginSearchObs: viewModel.beginSearchObs)
    private lazy var listNode = VAMainActorWrapperNode { [viewModel] in
        VAListNode(
            context: .init(
                listDataObs: viewModel.listDataObs,
                onSelect: { [weak viewModel] in viewModel?.perform(DidSelectEvent(indexPath: $0)) },
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
    }

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

    override func viewDidAnimateLayoutTransition(_ context: any ASContextTransitioning) {
        animateLayoutTransition(context: context)
    }

    override func viewDidLoad(in controller: UIViewController) {
        super.viewDidLoad(in: controller)
        
        bindKeyboardInset(scrollView: listNode.child.view, tabBarController: controller.tabBarController)
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
