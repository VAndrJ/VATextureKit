//
//  MainViewModel.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class MainViewModel {
    @Obs.Relay(value: [
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Layouts"), items: [
            MainListCellNodeViewModel(title: "Row", description: "Layout example", route: .rowLayout),
            MainListCellNodeViewModel(title: "Column", description: "Layout example", route: .columnLayout),
            MainListCellNodeViewModel(title: "Stack", description: "Layout example", route: .stackLayout),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Animations"), items: [
            MainListCellNodeViewModel(title: "Transition", description: "Layout transition animations", route: .moveAnimations),
            MainListCellNodeViewModel(title: "Custom", description: "Layer animations", route: .layerAnimations),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "System"), items: [
            MainListCellNodeViewModel(title: "Appearance", description: "Select theme", route: .apearance),
            MainListCellNodeViewModel(title: "Content size", description: "Alert controller", route: .contentSize),
            MainListCellNodeViewModel(title: "Alert", description: "Content size category name", route: .alert),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Gradient"), items: [
            MainListCellNodeViewModel(title: "Linear Gradient", description: "Gradient node examples", route: .linearGradient),
            MainListCellNodeViewModel(title: "Radial Gradient", description: "Gradient node examples", route: .radialGradient),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "List"), items: [
            MainListCellNodeViewModel(title: "List", description: "ASCollectionNode based", route: .collectionList),
            MainListCellNodeViewModel(title: "List", description: "ASCollectionNode based", route: .collectionListDifferentCells),
            MainListCellNodeViewModel(title: "List with header and footer\nMove items on long press", description: "ASCollectionNode based", route: .collectionListHeaderFooter),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Compositing"), items: [
            MainListCellNodeViewModel(title: "Blend mode", description: "Layer", route: .blendMode),
            MainListCellNodeViewModel(title: "Compositing filter", description: "Layer", route: .compositingFilter),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Components"), items: [
            MainListCellNodeViewModel(title: "VAShimmerNode", description: "Shimmering animation node", route: .shimmers),
            MainListCellNodeViewModel(title: "VATypingTextNode", description: "Typing animation text node", route: .typingText),
            MainListCellNodeViewModel(title: "VAReadMoreTextNode", description: "`Read more` truncation text node", route: .readMoreText),
            MainListCellNodeViewModel(title: "VAPagerNode", description: "ASPagerNode with improvements", route: .pager),
        ]),
        AnimatableSectionModel(model: MainSectionHeaderNodeViewModel(title: "Experiments"), items: [
            MainListCellNodeViewModel(title: "VACountingTextNode", description: "ASTextNode based", route: .countingTextNode),
            MainListCellNodeViewModel(title: "VASlidingTabBarNode", description: "ASScrollNode based", route: .slidingTabBar),
            MainListCellNodeViewModel(title: "VALinkTextNode", description: "ASTextNode based", route: .linkTextNode),
            MainListCellNodeViewModel(title: "Dynamic height grid list", description: "ASCollectionNode based", route: .dynamicHeightGridList),
        ]),
    ])
    var listDataObs: Observable<[AnimatableSectionModel<MainSectionHeaderNodeViewModel, MainListCellNodeViewModel>]>
    
    private let navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
    }
    
    func didSelect(indexPath: IndexPath) {
        let route = _listDataObs.rx.value[indexPath.section].items[indexPath.row].route
        navigator.navigate(to: route)
    }
}
