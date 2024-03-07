//
//  AppNavigator.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit
import VANavigator

class AppNavigator: Navigator {

    @MainActor
    func start() {
        navigate(
            destination: .identity(
                ExampleNavigationControllerIdentity(
                    root: MainNavigationIdentity()
                )
            ),
            strategy: .replaceWindowRoot(),
            animated: false
        )
    }

    nonisolated func navigate(to identity: NavigationIdentity) {
        Task { @MainActor in
            navigate(
                destination: .identity(identity),
                strategy: .push()
            )
        }
    }
}

class AppScreenFactory: NavigatorScreenFactory {
    private let themeManager: ThemeManager
    
    init(themeManager: ThemeManager) {
        self.themeManager = themeManager
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func assembleScreen(identity: NavigationIdentity, navigator: Navigator) -> UIViewController {
        switch identity {
        case let identity as ExampleNavigationControllerIdentity:
            ExampleNavigationController(
                rootViewController: assembleScreen(
                    identity: identity.root,
                    navigator: navigator
                ).apply {
                    $0.navigationIdentity = identity.root
                }
            )
        case _ as AppearanceNavigationIdentity:
            AppearanceViewController(viewModel: AppearanceViewModel(themeManager: themeManager))
        case _ as ContentSizeNavigationIdentity:
            ContentSizeViewController(node: ContentSizeControllerNode())
        case _ as LinearGradientNavigationIdentity:
            VAViewController(node: LinearGradientControllerNode())
        case _ as RadialGradientNavigationIdentity:
            VAViewController(node: RadialGradientControllerNode())
        case _ as AlertNavigationIdentity:
            AlertNodeController()
        case _ as CollectionListDifferentCellsNavigationIdentity:
            CollectionListDifferentCellsNodeController(viewModel: CollectionListDifferentCellsViewModel())
        case _ as CollectionListHeaderFooterNavigationIdentity:
            VAViewController(node: CollectionListHeaderFooterControllerNode(viewModel: CollectionListHeaderFooterViewModel()))
        case _ as TransitionAnimationNavigationIdentity:
            VAViewController(node: TransitionAnimationControllerNode(isPresented: false))
                .withAnimatedTransitionEnabled()
        case _ as LayerAnimationNavigationIdentity:
            VAViewController(node: LayerAnimationControllerNode())
        case _ as CompositingFilterNavigationIdentity:
            VAViewController(node: CompositingFilterControllerNode(viewModel: CompositingFilterViewModel()))
        case _ as BlendModeNavigationIdentity:
            VAViewController(node: CompositingFilterControllerNode(viewModel: BlendModeViewModel()))
        case _ as RowLayoutNavigationIdentity:
            VAViewController(node: RowLayoutControllerNode())
        case _ as ColumnLayoutNavigationIdentity:
            VAViewController(node: ColumnLayoutControllerNode())
        case _ as StackLayoutNavigationIdentity:
            VAViewController(node: StackLayoutControllerNode())
        case _ as TypingTextNavigationIdentity:
            VAViewController(node: TypingTextControllerNode())
        case _ as ReadMoreTextNavigationIdentity:
            VAViewController(node: ReadMoreTextControllerNode())
        case _ as PagerControllerNavigationIdentity:
            VAViewController(node: PagerControllerNode(viewModel: PagerControllerNodeViewModel()))
        case _ as SlidingTabBarNavigationIdentity:
            VAViewController(node: SlidingTabBarControllerNode())
        case _ as LinkTextNavigationIdentity:
            VAViewController(node: LinkTextControllerNode())
        case _ as CountingTextNodeNavigationIdentity:
            VAViewController(node: CountingTextNodeController())
        case _ as DynamicHeightGridListNavigationIdentity:
            VAViewController(node: DynamicHeightGridListControllerNode())
        case _ as ShimmersNavigationIdentity:
            VAViewController(node: ShimmersControllerNode())
        case _ as SpecBasedGridListNavigationIdentity:
            VAViewController(node: SpecBasedGridListControllerNode())
        case _ as GradientLayerAnimationNavigationIdentity:
            VAViewController(node: GradientLayerAnimationControllerNode())
        case _ as ShapeLayerAnimationNavigationIdentity:
            VAViewController(node: ShapeLayerAnimationControllerNode())
        case _ as FilterNavigationIdentity:
            VAViewController(node: FilterControllerNode())
        case _ as KeyframeAnimationsNavigationIdentity:
            VAViewController(node: KeyframeAnimationsControllerNode())
        case _ as ElementsScrollingAnimationListNavigationIdentity:
            ElementsScrollingAnimationListViewController()
        case _ as MainNavigationIdentity:
            MainNodeController(viewModel: MainViewModel(navigator: navigator as? AppNavigator))
        case _ as EmitterLayerAnimationNavigationIdentity:
            VAViewController(node: EmitterLayerAnimationControllerNode())
        case _ as SelfSizingListNavigationIdentity:
            VAViewController(node: SelfSizingListContainerControllerNode())
        default:
            fatalError("Not implemented")
        }
    }
}
