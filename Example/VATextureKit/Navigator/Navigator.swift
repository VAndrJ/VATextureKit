//
//  Navigator.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class Navigator {
    let screenFactory: ScreenFactory
    let navigationController: VANavigationController
    
    private var childNavigators: [Navigator] = []
    
    init(
        screenFactory: ScreenFactory,
        navigationController: VANavigationController,
        initialRoute: NavigationRoute? = nil
    ) {
        self.screenFactory = screenFactory
        self.navigationController = navigationController
        
        if let initialRoute {
            navigationController.setViewControllers(
                [screenFactory.create(route: initialRoute, navigator: self)],
                animated: false
            )
        }
    }
    
    func navigate(to route: NavigationRoute, animated: Bool = true) {
        navigationController.pushViewController(
            screenFactory.create(route: route, navigator: self),
            animated: animated
        )
    }

    // TODO: - child
//    func push(route: NavigationRoute) {
//        let navigator = Navigator(
//            screenFactory: screenFactory,
//            navigationController: ExampleNavigationController(),
//            initialRoute: route
//        )
//        navigationController.pushViewController(navigator.navigationController, animated: true)
//        childNavigators.append(navigator)
//    }
}

class ScreenFactory {
    private let themeManager: ThemeManager
    
    init(themeManager: ThemeManager) {
        self.themeManager = themeManager
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func create(route: NavigationRoute, navigator: Navigator) -> UIViewController {
        switch route {
        case .main:
            return MainNodeController(viewModel: MainViewModel(navigator: navigator))
        case .apearance:
            return AppearanceViewController(viewModel: AppearanceViewModel(themeManager: themeManager))
        case .contentSize:
            return ContentSizeViewController(node: ContentSizeControllerNode())
        case .linearGradient:
            return VAViewController(node: LinearGradientControllerNode())
        case .radialGradient:
            return VAViewController(node: RadialGradientControllerNode())
        case .alert:
            return AlertNodeController()
        case .collectionListDifferentCells:
            return CollectionListDifferentCellsNodeController(viewModel: CollectionListDifferentCellsViewModel())
        case .collectionListHeaderFooter:
            return VAViewController(node: CollectionListHeaderFooterControllerNode(viewModel: CollectionListHeaderFooterViewModel()))
        case .moveAnimations:
            return VAViewController(node: TransitionAnimationControllerNode(isPresented: false))
                .withAnimatedTransitionEnabled()
        case .layerAnimations:
            return VAViewController(node: LayerAnimationControllerNode())
        case .compositingFilter:
            return VAViewController(node: CompositingFilterControllerNode(viewModel: CompositingFilterViewModel()))
        case .blendMode:
            return VAViewController(node: CompositingFilterControllerNode(viewModel: BlendModeViewModel()))
        case .rowLayout:
            return VAViewController(node: RowLayoutControllerNode())
        case .columnLayout:
            return VAViewController(node: ColumnLayoutControllerNode())
        case .stackLayout:
            return VAViewController(node: StackLayoutControllerNode())
        case .typingText:
            return VAViewController(node: TypingTextControllerNode())
        case .readMoreText:
            return VAViewController(node: ReadMoreTextControllerNode())
        case .pager:
            return VAViewController(node: PagerControllerNode(viewModel: PagerControllerNodeViewModel()))
        case .slidingTabBar:
            return VAViewController(node: SlidingTabBarControllerNode())
        case .linkTextNode:
            return VAViewController(node: LinkTextControllerNode())
        case .countingTextNode:
            return VAViewController(node: CountingTextNodeController())
        case .dynamicHeightGridList:
            return VAViewController(node: DynamicHeightGridListControllerNode())
        case .shimmers:
            return VAViewController(node: ShimmersControllerNode())
        case .specBasedGridList:
            return VAViewController(node: SpecBasedGridListControllerNode())
        case .gradientLayerAnimations:
            return VAViewController(node: GradientLayerAnimationControllerNode())
        case .shapeLayerAnimations:
            return VAViewController(node: ShapeLayerAnimationControllerNode())
        case .filter:
            return VAViewController(node: FilterControllerNode())
        case .keyframeLayerAnimations:
            return VAViewController(node: KeyframeAnimationsControllerNode())
        case .elementsScrollingAnimationList:
            return ElementsScrollingAnimationListViewController()
        }
    }
}
