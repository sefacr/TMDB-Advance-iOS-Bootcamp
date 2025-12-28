//
//  ShowListPresenter.swift
//  MovieCleanSwift
//
//  Created by Seyfeddin Bassarac on 26.09.2025.
//

import Foundation

protocol ShowListPresenterInput: AnyObject {
    func displayShows(response: ShowListResponse)
    func showLoading(isLoading: Bool)
}

protocol ShowListPresenterOutput: AnyObject {
    func showTvShows(tvShows: [ShowListViewModel])
    func showLoading(isLoading: Bool)
}

class ShowListPresenter: ShowListPresenterInput {

    weak var output: ShowListPresenterOutput!
    
    func displayShows(response: ShowListResponse) {
        let viewModels: [ShowListViewModel] = response.shows.map(
            {
                ShowListViewModel(
                id: $0.id,
                posterPath: $0.posterPath
                )
            })
        
        output.showTvShows(tvShows: viewModels)
    }
    
    func showLoading(isLoading: Bool) {
        output.showLoading(isLoading: isLoading)
    }
}
