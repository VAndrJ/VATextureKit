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
            return ExampleNavigationController(
                rootViewController: assembleScreen(
                    identity: identity.root,
                    navigator: navigator
                ).apply {
                    $0.navigationIdentity = identity.root
                }
            )
        case _ as AppearanceNavigationIdentity:
            return AppearanceViewController(viewModel: AppearanceViewModel(themeManager: themeManager))
        case _ as ContentSizeNavigationIdentity:
            return ContentSizeViewController(node: ContentSizeControllerNode())
        case _ as LinearGradientNavigationIdentity:
            return VAViewController(node: LinearGradientControllerNode())
        case _ as RadialGradientNavigationIdentity:
            return VAViewController(node: RadialGradientControllerNode())
        case _ as AlertNavigationIdentity:
            return AlertNodeController()
        case _ as CollectionListDifferentCellsNavigationIdentity:
            return CollectionListDifferentCellsNodeController(viewModel: CollectionListDifferentCellsViewModel())
        case _ as CollectionListHeaderFooterNavigationIdentity:
            return VAViewController(node: CollectionListHeaderFooterControllerNode(viewModel: CollectionListHeaderFooterViewModel()))
        case _ as TransitionAnimationNavigationIdentity:
            return VAViewController(node: TransitionAnimationControllerNode(isPresented: false))
                .withAnimatedTransitionEnabled()
        case _ as LayerAnimationNavigationIdentity:
            return VAViewController(node: LayerAnimationControllerNode())
        case _ as CompositingFilterNavigationIdentity:
            return VAViewController(node: CompositingFilterControllerNode(viewModel: CompositingFilterViewModel()))
        case _ as BlendModeNavigationIdentity:
            return VAViewController(node: CompositingFilterControllerNode(viewModel: BlendModeViewModel()))
        case _ as RowLayoutNavigationIdentity:
            return VAViewController(node: RowLayoutControllerNode())
        case _ as ColumnLayoutNavigationIdentity:
            return VAViewController(node: ColumnLayoutControllerNode())
        case _ as StackLayoutNavigationIdentity:
            return VAViewController(node: StackLayoutControllerNode())
        case _ as TypingTextNavigationIdentity:
            return VAViewController(node: TypingTextControllerNode())
        case _ as ReadMoreTextNavigationIdentity:
            return VAViewController(node: ReadMoreTextControllerNode())
        case _ as PagerControllerNavigationIdentity:
            return VAViewController(node: PagerControllerNode(viewModel: PagerControllerNodeViewModel()))
        case _ as SlidingTabBarNavigationIdentity:
            return VAViewController(node: SlidingTabBarControllerNode())
        case _ as LinkTextNavigationIdentity:
            return VAViewController(node: LinkTextControllerNode())
        case _ as CountingTextNodeNavigationIdentity:
            return VAViewController(node: CountingTextNodeController())
        case _ as DynamicHeightGridListNavigationIdentity:
            return VAViewController(node: DynamicHeightGridListControllerNode())
        case _ as ShimmersNavigationIdentity:
            return VAViewController(node: ShimmersControllerNode())
        case _ as SpecBasedGridListNavigationIdentity:
            return VAViewController(node: SpecBasedGridListControllerNode())
        case _ as GradientLayerAnimationNavigationIdentity:
            return VAViewController(node: GradientLayerAnimationControllerNode())
        case _ as ShapeLayerAnimationNavigationIdentity:
            return VAViewController(node: ShapeLayerAnimationControllerNode())
        case _ as FilterNavigationIdentity:
            return VAViewController(node: FilterControllerNode())
        case _ as KeyframeAnimationsNavigationIdentity:
            return VAViewController(node: KeyframeAnimationsControllerNode())
        case _ as ElementsScrollingAnimationListNavigationIdentity:
            return ElementsScrollingAnimationListViewController()
        case _ as MainNavigationIdentity:
            return MainNodeController(viewModel: MainViewModel(navigator: navigator as? AppNavigator))
        case _ as EmitterLayerAnimationNavigationIdentity:
            return VAViewController(node: EmitterLayerAnimationControllerNode())
        case _ as SelfSizingListNavigationIdentity:
            return VAViewController(node: SelfSizingListContainerControllerNode())
        default:
            fatalError("Not implemented")
        }
    }
}
