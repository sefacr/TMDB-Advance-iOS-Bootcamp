//
//  ShowDetailViewModel.swift
//  MovieList
//
//  Created by Sefa Acar on 28.01.2026.
//

import Foundation

protocol ShowDetailViewModelProtocol: AnyObject {
    var delegate: ShowDetailViewModelDelegate? { get set }
    func loadData()
}

enum ShowDetailViewModelOutput {
    case showLoading(Bool)
    case displayShow(ShowDetailPresentation)
}

protocol ShowDetailViewModelDelegate: AnyObject {
    func handleOutput(_ output: ShowDetailViewModelOutput)
}

final class ShowDetailViewModel: ShowDetailViewModelProtocol {
    
    var delegate: (any ShowDetailViewModelDelegate)?
    
    var tvShow: TVSeries!
    
    private var service: ShowDetailServiceProtocol
    
    init(tvShow: TVSeries!, service: ShowDetailServiceProtocol) {
        self.tvShow = tvShow
        self.service = service
    }
    
    func loadData() {
        delegate?.handleOutput(.showLoading(true))
        service.fetchDetailedTVSeries(id: tvShow.id) { [weak self] result in
            guard let self else { return }
            delegate?.handleOutput(.showLoading(false))
            switch result {
            case .success(let tvShow):
                self.tvShow = tvShow
                let showDetailPresentation = ShowDetailPresentation(with: tvShow)
                delegate?.handleOutput(.displayShow(showDetailPresentation))
            case .failure(let error):
                print(error)
            }
        }
    }
}
