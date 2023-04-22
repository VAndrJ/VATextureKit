//
//  CollectionListHeaderFooterViewModel.swift
//  VATextureKit_Tests
//
//  Created by VAndrJ on 22.04.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import VATextureKit

final class CollectionListHeaderFooterViewModel {
    @Obs.Relay(value: [
        AnimatableSectionModel(
            model: CollectionListSectionHeaderFooterViewModel(
                headerViewModel: CollectionListSectionHeaderViewModel(title: "Header"),
                footerViewModel: CollectionListSectionFooterViewModel(title: "Footer")
            ),
            items: (0...3).map { ImageNumberCellNodeViewModel(image: testImages.randomElement(), ratio: 1 / 3, number: $0) }
        ),
        AnimatableSectionModel(
            model: CollectionListSectionHeaderFooterViewModel(
                headerViewModel: CollectionListSectionHeaderViewModel(title: "Header")
            ),
            items: (0...3).map { ImageNumberCellNodeViewModel(image: testImages.randomElement(), ratio: 1 / 3, number: $0) }
        ),
        AnimatableSectionModel(
            model: CollectionListSectionHeaderFooterViewModel(
                footerViewModel: CollectionListSectionFooterViewModel(title: "Footer")
            ),
            items: (0...3).map { ImageNumberCellNodeViewModel(image: testImages.randomElement(), ratio: 1 / 3, number: $0) }
        ),
    ])
    var listDataObs: Observable<[AnimatableSectionModel<CollectionListSectionHeaderFooterViewModel, CellViewModel>]>
}

class CollectionListSectionHeaderCellNode: VACellNode {
    private let titleTextNode: VATextNode

    init(viewModel: CollectionListSectionHeaderViewModel) {
        self.titleTextNode = VATextNode(text: viewModel.title)

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleTextNode
            .padding(.all(16))
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemOrange
    }
}

class CollectionListSectionHeaderViewModel: CellViewModel {
    let title: String

    init(title: String) {
        self.title = title
    }
}

class CollectionListSectionFooterCellNode: VACellNode {
    private let titleTextNode: VATextNode

    init(viewModel: CollectionListSectionFooterViewModel) {
        self.titleTextNode = VATextNode(text: viewModel.title)

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleTextNode
            .padding(.all(16))
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemGreen
    }
}

class CollectionListSectionFooterViewModel: CellViewModel {
    let title: String

    init(title: String) {
        self.title = title
    }
}

class CollectionListSectionHeaderFooterViewModel: CellViewModel {
    let headerViewModel: CollectionListSectionHeaderViewModel?
    let footerViewModel: CollectionListSectionFooterViewModel?

    init(headerViewModel: CollectionListSectionHeaderViewModel? = nil, footerViewModel: CollectionListSectionFooterViewModel? = nil) {
        self.headerViewModel = headerViewModel
        self.footerViewModel = footerViewModel
    }
}
