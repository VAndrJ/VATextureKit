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

    nonisolated func navigate(
        to identity: any NavigationIdentity,
        strategy: NavigationStrategy = .push()
    ) {
        Task { @MainActor in
            navigate(
                destination: .identity(identity),
                strategy: strategy
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
    func assembleScreen(identity: any NavigationIdentity, navigator: Navigator) -> UIViewController {
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
            return ContentSizeNodeController()
        case _ as LinearGradientNavigationIdentity:
            return VAViewController(node: LinearGradientScreenNode())
        case _ as RadialGradientNavigationIdentity:
            return VAViewController(node: RadialGradientScreenNode())
        case _ as AlertNavigationIdentity:
            return AlertNodeController(context: .init(
                navigation: .init(
                    showAlert: navigator ?> {
                        $0.navigate(
                            destination: .controller($1),
                            strategy: .present()
                        )
                    }
                )
            ))
        case _ as CollectionListDifferentCellsNavigationIdentity:
            return CollectionListDifferentCellsNodeController(viewModel: CollectionListDifferentCellsViewModel())
        case _ as CollectionListHeaderFooterNavigationIdentity:
            return VAViewController(node: CollectionListHeaderFooterScreenNode(viewModel: CollectionListHeaderFooterViewModel()))
        case _ as TransitionAnimationNavigationIdentity:
            return VAViewController(node: TransitionAnimationScreenNode(isPresented: false))
                .withAnimatedTransitionEnabled()
        case _ as LayerAnimationNavigationIdentity:
            return VAViewController(node: LayerAnimationScreenNode())
        case _ as CompositingFilterNavigationIdentity:
            return VAViewController(node: CompositingFilterScreenNode(viewModel: CompositingFilterViewModel()))
        case _ as BlendModeNavigationIdentity:
            return VAViewController(node: CompositingFilterScreenNode(viewModel: BlendModeViewModel()))
        case _ as RowLayoutNavigationIdentity:
            return VAViewController(node: RowLayoutScreenNode())
        case _ as ColumnLayoutNavigationIdentity:
            return VAViewController(node: ColumnLayoutScreenNode())
        case _ as StackLayoutNavigationIdentity:
            return VAViewController(node: StackLayoutScreenNode())
        case _ as TypingTextNavigationIdentity:
            return VAViewController(node: TypingTextScreenNode())
        case _ as ReadMoreTextNavigationIdentity:
            return VAViewController(node: ReadMoreTextScreenNode())
        case _ as PagerControllerNavigationIdentity:
            return VAViewController(node: PagerScreenNode(viewModel: PagerScreenNodeViewModel()))
        case _ as SlidingTabBarNavigationIdentity:
            return VAViewController(node: SlidingTabBarScreenNode())
        case _ as LinkTextNavigationIdentity:
            return VAViewController(node: LinkTextScreenNode())
        case _ as CountingTextNodeNavigationIdentity:
            return VAViewController(node: CountingTextNodeController())
        case _ as DynamicHeightGridListNavigationIdentity:
            return VAViewController(node: DynamicHeightGridListScreenNode())
        case _ as ShimmersNavigationIdentity:
            return VAViewController(node: ShimmersScreenNode())
        case _ as SpecBasedGridListNavigationIdentity:
            return VAViewController(node: SpecBasedGridListScreenNode())
        case _ as GradientLayerAnimationNavigationIdentity:
            return VAViewController(node: GradientLayerAnimationScreenNode())
        case _ as ShapeLayerAnimationNavigationIdentity:
            return VAViewController(node: ShapeLayerAnimationScreenNode())
        case _ as FilterNavigationIdentity:
            return VAViewController(node: FilterScreenNode())
        case _ as KeyframeAnimationsNavigationIdentity:
            return VAViewController(node: KeyframeAnimationsScreenNode())
        case _ as ElementsScrollingAnimationListNavigationIdentity:
            return ElementsScrollingAnimationListNodeController()
        case _ as MainNavigationIdentity:
            return MainNodeController(viewModel: MainViewModel(navigator: navigator as? AppNavigator))
        case _ as EmitterLayerAnimationNavigationIdentity:
            return VAViewController(node: EmitterLayerAnimationScreenNode())
        case _ as SelfSizingListNavigationIdentity:
            return VAViewController(node: SelfSizingListContainerScreenNode())
        case _ as UIViewSizedContainerNavigationIdentity:
            return VAViewController(node: UIViewSizedContainerScreenNode())
        case _ as UIViewContainerNavigationIdentity:
            return VAViewController(node: UIViewContainerScreenNode())
        case _ as ViewHostingNavigationIdentity:
            return VAViewController(node: ViewHostingScreenNode())
        case _ as VAComparisonNodeIdentity:
            return VAViewController(node: VAComparisonNodeScreenNode())
        case _ as VAVisualEffectIdentity:
            return VAViewController(node: VAVisualEffectScreenNode())
        default:
            fatalError("Not implemented")
        }
    }
}
