//
//  ShowDetailInteractor.swift
//  MovieViper
//
//  Created by Sefa Acar on 28.12.2025.
//

import Foundation

final class ShowDetailInteractor: ShowDetailInteractorProtocol {
    
    var delegate: (any ShowDetailInteractorDelegate)?
    
    let service: ShowDetailServiceProtocol!
    
    var tvShow: TVSeries!
    
    init(tvShow: TVSeries, service: ShowDetailServiceProtocol!) {
        self.service = service
        self.tvShow = tvShow
    }
    
    func loadData() {
        delegate?.handleOutput(.showLoading(true))
        service.fetchDetailedTVSeries(id: tvShow.id) { [weak self] result in
            guard let self else { return }
            delegate?.handleOutput(.showLoading(false))
            switch result {
            case .success(let tvSerie):
                delegate?.handleOutput(.showTVSeries(tvSerie))
            case .failure(let error):
                print(error)
            }
        }
    }
}
