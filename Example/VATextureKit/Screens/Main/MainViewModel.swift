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
            MainListCellNodeViewModel(title: "Row", description: "Layout example", destination: RowLayoutNavigationIdentity()),
            MainListCellNodeViewModel(title: "Column", description: "Layout example", destination: ColumnLayoutNavigationIdentity()),
            MainListCellNodeViewModel(title: "Stack", description: "Layout example", destination: StackLayoutNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Animations"), items: [
            MainListCellNodeViewModel(title: "Transition", description: "Layout transition animations", destination: TransitionAnimationNavigationIdentity(), titleTransitionAnimationId: "Test", descriptionTransitionAnimationId: "Test1"),
            MainListCellNodeViewModel(title: "Layer", description: "Layer animations", destination: LayerAnimationNavigationIdentity()),
            MainListCellNodeViewModel(title: "Gradient Layer", description: "Layer animations", destination: GradientLayerAnimationNavigationIdentity()),
            MainListCellNodeViewModel(title: "Shape layer", description: "Layer animations", destination: ShapeLayerAnimationNavigationIdentity()),
            MainListCellNodeViewModel(title: "Keyframe", description: "Layer animations", destination: KeyframeAnimationsNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "System"), items: [
            MainListCellNodeViewModel(title: "Appearance", description: "Select theme", destination: AppearanceNavigationIdentity()),
            MainListCellNodeViewModel(title: "Content size", description: "Content size category name", destination: ContentSizeNavigationIdentity()),
            MainListCellNodeViewModel(title: "Alert", description: "Alert controller", destination: AlertNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Gradient"), items: [
            MainListCellNodeViewModel(title: "Linear Gradient", description: "Gradient node examples", destination: LinearGradientNavigationIdentity()),
            MainListCellNodeViewModel(title: "Radial Gradient", description: "Gradient node examples", destination: RadialGradientNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "List"), items: [
            MainListCellNodeViewModel(title: "List with different cells", description: "ASCollectionNode based", destination: CollectionListDifferentCellsNavigationIdentity()),
            MainListCellNodeViewModel(title: "List with header and footer\nMove items on long press", description: "ASCollectionNode based", destination: CollectionListHeaderFooterNavigationIdentity()),
            MainListCellNodeViewModel(title: "Dynamic height grid list layout", description: "ASCollectionNode based", destination: DynamicHeightGridListNavigationIdentity()),
            MainListCellNodeViewModel(title: "Spec based grid list layout", description: "ASCollectionNode based", destination: SpecBasedGridListNavigationIdentity()),
            MainListCellNodeViewModel(title: "Cells responding to scroll", description: "ASCollectionNode based", destination: ElementsScrollingAnimationListNavigationIdentity()),
            MainListCellNodeViewModel(title: "Self-sizing list container", description: "For ASCollectionNode", destination: SelfSizingListNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Compositing"), items: [
            MainListCellNodeViewModel(title: "Blend mode", description: "Layer", destination: BlendModeNavigationIdentity()),
            MainListCellNodeViewModel(title: "Compositing filter", description: "Layer", destination: CompositingFilterNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Components"), items: [
            MainListCellNodeViewModel(title: "VAShimmerNode", description: "Shimmering animation node", destination: ShimmersNavigationIdentity()),
            MainListCellNodeViewModel(title: "VATypingTextNode", description: "Typing animation text node", destination: TypingTextNavigationIdentity()),
            MainListCellNodeViewModel(title: "VACountingTextNode", description: "ASTextNode based", destination: CountingTextNodeNavigationIdentity()),
            MainListCellNodeViewModel(title: "VAReadMoreTextNode", description: "`Read more` truncation text node", destination: ReadMoreTextNavigationIdentity()),
            MainListCellNodeViewModel(title: "VAPagerNode", description: "ASPagerNode with improvements", destination: PagerControllerNavigationIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Containers"), items: [
            MainListCellNodeViewModel(title: "UIView container", description: "Autolayout UIView, different sizing", destination: UIViewSizedContainerNavigationIdentity()),
            MainListCellNodeViewModel(title: "UIView container", description: "UIView, different sizing", destination: UIViewContainerNavigationIdentity()),
            MainListCellNodeViewModel(title: "View container", description: "SwiftUI View, different sizing", destination: ViewHostingNavigationIdentity()),
            MainListCellNodeViewModel(title: "Nodes comparison container", description: "Slide-to-compare node", destination: VAComparisonNodeIdentity()),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Experiments"), items: [
            MainListCellNodeViewModel(title: "Emitter", description: "CAEmitterLayer based node", destination: EmitterLayerAnimationNavigationIdentity()),
            MainListCellNodeViewModel(title: "VALinkTextNode", description: "ASTextNode based", destination: LinkTextNavigationIdentity()),
            MainListCellNodeViewModel(title: "VASlidingTabBarNode", description: "ASScrollNode based", destination: SlidingTabBarNavigationIdentity()),
            MainListCellNodeViewModel(title: "Filter", description: "Experiments", destination: FilterNavigationIdentity()),
        ]),
    ])
    var listDataObs: Observable<[AnimatableSectionModel<MainSectionHeaderNodeViewModel, MainListCellNodeViewModel>]>
    
    private weak var navigator: AppNavigator?

    init(navigator: AppNavigator?) {
        self.navigator = navigator
    }
    
    func didSelect(indexPath: IndexPath) {
        let destination = _listDataObs.rx.value[indexPath.section].items[indexPath.row].destination
        navigator?.navigate(to: destination)
    }
}
