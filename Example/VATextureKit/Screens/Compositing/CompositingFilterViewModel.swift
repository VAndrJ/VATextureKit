//
//  CompositingFilterViewModel.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 05.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import RxSwift

protocol CompositingFilterViewModelProtocol {
    var selectedFilterObs: Observable<String?> { get }
    var filtersObs: Observable<[CompositingCellNodeViewModel]> { get }

    func didSelect(indexPath: IndexPath)
}

class CompositingFilterViewModel: CompositingFilterViewModelProtocol {
    @Obs.Relay(value: nil)
    var selectedFilterObs: Observable<String?>
    @Obs.Relay(
        value: ASDisplayNode.CompositingFilter.allCases,
        map: { $0.map { CompositingCellNodeViewModel.init(compositingFilter: $0) } }
    )
    var filtersObs: Observable<[CompositingCellNodeViewModel]>

    func didSelect(indexPath: IndexPath) {
        _selectedFilterObs.rx.accept(_filtersObs.rx.value[indexPath.item].rawValue)
    }
}

class BlendModeViewModel: CompositingFilterViewModelProtocol {
    @Obs.Relay(value: nil)
    var selectedFilterObs: Observable<String?>
    @Obs.Relay(
        value: ASDisplayNode.BlendMode.allCases,
        map: { $0.map { CompositingCellNodeViewModel.init(blendMode: $0) } }
    )
    var filtersObs: Observable<[CompositingCellNodeViewModel]>

    func didSelect(indexPath: IndexPath) {
        _selectedFilterObs.rx.accept(_filtersObs.rx.value[indexPath.item].rawValue)
    }
}
