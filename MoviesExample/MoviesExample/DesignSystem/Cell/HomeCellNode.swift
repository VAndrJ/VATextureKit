//
//  HomeCellNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 05.05.2023.
//

import VATextureKitRx
import RxSwift
import RxCocoa

final class HomeCellNode: VACellNode, @unchecked Sendable {
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

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    private func bind() {
    }
}

struct HomeCellTabData {
    let name: String
    let data: Observable<[ListMovieEntity]>
}

final class HomeCellNodeViewModel: CellViewModel {
    let data: Observable<[HomeCellTabData]?>

    init(data: Observable<[HomeCellTabData]?>) {
        self.data = data

        super.init()
    }
}
