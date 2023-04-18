//
//  CompositingFilterControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 05.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit
import Swiftional

// MARK: - View with ViewModel example. Code organization example

final class CompositingFilterControllerNode: VASafeAreaDisplayNode {

    // MARK: - UI related code

    private(set) lazy var backgroundImageNode = VAImageNode(data: .init(
        image: R.image.moon(),
        contentMode: .scaleAspectFill
    ))
    private(set) lazy var composingImageNode = VAImageNode(data: .init(
        image: R.image.colibri(),
        contentMode: .scaleAspectFill
    ))
    private(set) lazy var listNode = VATableListNode(data: .init(
        configuration: .init(shouldDeselect: (false, true)),
        listDataObs: viewModel.filtersObs,
        onSelect: viewModel.didSelect(indexPath:),
        cellGetter: CompositingCellNode.init(viewModel:)
    ))

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        (constrainedSize.max.width > constrainedSize.max.height).fold {
            Column(cross: .stretch) {
                backgroundImageNode
                    .ratio(1)
                    .overlay(composingImageNode)
                listNode
                    .safe(edges: .bottom, in: self)
                    .flex(grow: 1)
            }
        } _: {
            SafeArea(edges: [.vertical, .right]) {
                Row(cross: .stretch) {
                    backgroundImageNode
                        .ratio(1)
                        .overlay(composingImageNode)
                    listNode
                        .flex(grow: 1)
                }
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }

    // MARK: - ViewModel related code

    let viewModel: CompositingFilterViewModelProtocol

    private let bag = DisposeBag()

    init(viewModel: CompositingFilterViewModelProtocol) {
        self.viewModel = viewModel

        super.init()
    }

    override func didLoad() {
        super.didLoad()

        bind()
    }

    private func bind() {
        viewModel.selectedFilterObs
            .map { $0 as Any }
            .bind(to: composingImageNode.layer.rx.compositingFilter)
            .disposed(by: bag)
        /*
        or

        composingImageNode.compositingFilter
        composingImageNode.blendMode

        variables
        */
    }
}
