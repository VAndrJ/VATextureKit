//
//  HomeCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 05.05.2023.
//

import VATextureKitRx

class HomeCellNode: VACellNode {
    let viewModel: HomeCellNodeViewModel

    private var isDataLoaded = false
    private lazy var tabsNode = ASDisplayNode()
    private lazy var shimmerNode = ShimmerCellNode(viewModel: .init(kind: .homeCell))
    private let bag = DisposeBag()

    init(viewModel: HomeCellNodeViewModel) {
        self.viewModel = viewModel
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        shimmerNode
            .wrapped()
    }

    override func didLoad() {
        super.didLoad()

        bind()
    }

    private func bind() {
    }
}

struct HomeCellTabData {
    let name: String
    let data: Observable<[ListMovieEntity]>
}

class HomeCellNodeViewModel: CellViewModel {
    let data: Observable<[HomeCellTabData]?>

    init(data: Observable<[HomeCellTabData]?>) {
        self.data = data

        super.init()
    }
}
