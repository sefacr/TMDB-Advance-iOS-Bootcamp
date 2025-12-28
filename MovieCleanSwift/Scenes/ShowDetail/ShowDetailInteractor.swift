//
//  ShowDetailInteractor.swift
//  MovieCleanSwift
//
//  Created by Seyfeddin Bassarac on 27.09.2025.
//

import Foundation

protocol ShowDetailInteractorInput: AnyObject {
    func loadData(request: ShowDetailRequest)
}

protocol ShowDetailInteractorOutput: AnyObject {
    func showDetail(response: ShowDetailResponse)
}

protocol ShowDetailDataStore: AnyObject {
    var tvShow: TVSeries! { get set }
}

class ShowDetailInteractor: ShowDetailInteractorInput, ShowDetailDataStore {
    
    var worker: ShowDetailWorker!
    var tvShow: TVSeries!
    var output: ShowDetailInteractorOutput!
    
    func loadData(request: ShowDetailRequest) {
        worker = ShowDetailWorker()
        worker.fetchDetailedTVSeries(id: tvShow.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let show):
                self.tvShow = show
                let response = ShowDetailResponse(tvShow: show)
                self.output.showDetail(response: response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
