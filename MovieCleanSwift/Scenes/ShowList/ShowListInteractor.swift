//
//  ShowListInteractor.swift
//  MovieCleanSwift
//
//  Created by Seyfeddin Bassarac on 26.09.2025.
//

import Foundation

protocol ShowListInteractorInput: AnyObject {
    func loadData(request: ShowListRequest)
}

protocol ShowListInteractorOutput: AnyObject {
    func displayShows(response: ShowListResponse)
    func showLoading(isLoading: Bool)
}

protocol ShowListDataStore: AnyObject {
    var shows: [TVSeries]? { get}
}

class ShowListInteractor: ShowListInteractorInput, ShowListDataStore {
    
    var output: ShowListInteractorOutput!
    var worker: ShowListWorker!
    var shows: [TVSeries]?
    
    func loadData(request: ShowListRequest) {
        worker = ShowListWorker()
        output.showLoading(isLoading: true)
        worker.fetchPopularTvSeries { [weak self] result in
            guard let self = self else { return }
            self.output.showLoading(isLoading: false)
            switch result {
            case .success(let shows):
                self.shows = shows
                let response = ShowListResponse(shows: shows)
                self.output.displayShows(response: response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
