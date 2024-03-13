//
//  MainViewModel.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

final class MainViewModel {
    @Obs.Relay(value: [
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Layouts"), items: [
            MainListCellNodeViewModel(title: "Row", description: "Layout example", route: RowLayoutNavigationIdentity()),
            MainListCellNodeViewModel(title: "Column", description: "Layout example", route: ColumnLayoutNavigationIdentity()),
            MainListCellNodeViewModel(title: "Stack", description: "Layout example", route: StackLayoutNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Animations"), items: [
            MainListCellNodeViewModel(title: "Transition", description: "Layout transition animations", route: TransitionAnimationNavigationIdentity(), titleTransitionAnimationId: "Test", descriptionTransitionAnimationId: "Test1"),
            MainListCellNodeViewModel(title: "Layer", description: "Layer animations", route: LayerAnimationNavigationIdentity()),
            MainListCellNodeViewModel(title: "Gradient Layer", description: "Layer animations", route: GradientLayerAnimationNavigationIdentity()),
            MainListCellNodeViewModel(title: "Shape layer", description: "Layer animations", route: ShapeLayerAnimationNavigationIdentity()),
            MainListCellNodeViewModel(title: "Keyframe", description: "Layer animations", route: KeyframeAnimationsNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "System"), items: [
            MainListCellNodeViewModel(title: "Appearance", description: "Select theme", route: AppearanceNavigationIdentity()),
            MainListCellNodeViewModel(title: "Content size", description: "Content size category name", route: ContentSizeNavigationIdentity()),
            MainListCellNodeViewModel(title: "Alert", description: "Alert controller", route: AlertNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Gradient"), items: [
            MainListCellNodeViewModel(title: "Linear Gradient", description: "Gradient node examples", route: LinearGradientNavigationIdentity()),
            MainListCellNodeViewModel(title: "Radial Gradient", description: "Gradient node examples", route: RadialGradientNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "List"), items: [
            MainListCellNodeViewModel(title: "List with different cells", description: "ASCollectionNode based", route: CollectionListDifferentCellsNavigationIdentity()),
            MainListCellNodeViewModel(title: "List with header and footer\nMove items on long press", description: "ASCollectionNode based", route: CollectionListHeaderFooterNavigationIdentity()),
            MainListCellNodeViewModel(title: "Dynamic height grid list layout", description: "ASCollectionNode based", route: DynamicHeightGridListNavigationIdentity()),
            MainListCellNodeViewModel(title: "Spec based grid list layout", description: "ASCollectionNode based", route: SpecBasedGridListNavigationIdentity()),
            MainListCellNodeViewModel(title: "Cells responding to scroll", description: "ASCollectionNode based", route: ElementsScrollingAnimationListNavigationIdentity()),
            MainListCellNodeViewModel(title: "Self-sizing list container", description: "For ASCollectionNode", route: SelfSizingListNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Compositing"), items: [
            MainListCellNodeViewModel(title: "Blend mode", description: "Layer", route: BlendModeNavigationIdentity()),
            MainListCellNodeViewModel(title: "Compositing filter", description: "Layer", route: CompositingFilterNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Components"), items: [
            MainListCellNodeViewModel(title: "VAShimmerNode", description: "Shimmering animation node", route: ShimmersNavigationIdentity()),
            MainListCellNodeViewModel(title: "VATypingTextNode", description: "Typing animation text node", route: TypingTextNavigationIdentity()),
            MainListCellNodeViewModel(title: "VACountingTextNode", description: "ASTextNode based", route: CountingTextNodeNavigationIdentity()),
            MainListCellNodeViewModel(title: "VAReadMoreTextNode", description: "`Read more` truncation text node", route: ReadMoreTextNavigationIdentity()),
            MainListCellNodeViewModel(title: "VAPagerNode", description: "ASPagerNode with improvements", route: PagerControllerNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Containers"), items: [
            MainListCellNodeViewModel(title: "UIView container", description: "Autolayout UIView, different sizing", route: UIViewContainerNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Experiments"), items: [
            MainListCellNodeViewModel(title: "Emitter", description: "CAEmitterLayer based node", route: EmitterLayerAnimationNavigationIdentity()),
            MainListCellNodeViewModel(title: "VALinkTextNode", description: "ASTextNode based", route: LinkTextNavigationIdentity()),
            MainListCellNodeViewModel(title: "VASlidingTabBarNode", description: "ASScrollNode based", route: SlidingTabBarNavigationIdentity()),
            MainListCellNodeViewModel(title: "Filter", description: "Experiments", route: FilterNavigationIdentity()),
        ]),
    ])
    var listDataObs: Observable<[AnimatableSectionModel<MainSectionHeaderNodeViewModel, MainListCellNodeViewModel>]>
    
    private weak var navigator: AppNavigator?

    init(navigator: AppNavigator?) {
        self.navigator = navigator
    }
    
    func didSelect(indexPath: IndexPath) {
        let route = _listDataObs.rx.value[indexPath.section].items[indexPath.row].route
        navigator?.navigate(to: route)
    }
}
