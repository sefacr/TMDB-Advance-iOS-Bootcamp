//
//  ShowListInteractor.swift
//  MovieViper
//
//  Created by Sefa Acar on 26.12.2025.
//

import Foundation

final class ShowListInteractor: ShowListInteractorProtocol {
        
    weak var delegate: ShowListInteractorDelegate?
    var service: ShowListServiceProtocol!
    
    init(service: ShowListServiceProtocol!) {
        self.service = service
    }
    
    func loadData() {
        self.delegate?.handleOutput(.showLoading(true))
        service.fetchPopularTvSeries { [weak self] result in
//            guard let self = self else { return }
            // swift 5 ile beraber sağdaki ve soldaki aynı isimse direk self diyebiliyorum.
            guard let self else { return }
            self.delegate?.handleOutput(.showLoading(false))
            //self'i zaten unwrapplediğimiz için delegate başına self demeyebilirim.
            switch result {
            case .success(let tvSeries):
                self.delegate?.handleOutput(.showTVSeries(tvSeries))
            case .failure(let error):
                print(error)
            }
        }
    }
}
