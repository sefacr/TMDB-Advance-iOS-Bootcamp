//
//  ShowDetailPresenter.swift
//  MovieCleanSwift
//
//  Created by Seyfeddin Bassarac on 27.09.2025.
//

import Foundation

protocol ShowDetailPresenterInput {
    func showDetail(response: ShowDetailResponse)
}

protocol ShowDetailPresenterOutput: AnyObject {
    func displayShow(tvShow: ShowDetailViewModel)
}

class ShowDetailPresenter: ShowDetailPresenterInput {
    
    weak var output: ShowDetailPresenterOutput?
    
    func showDetail(response: ShowDetailResponse) {
        let show = response.tvShow
        let viewModel = ShowDetailViewModel(
            id: show.id,
            posterPath: show.posterPath,
            tagline: show.tagline,
            name: show.name,
            originalName: show.originalName,
            firstAirDate: show.firstAirDate,
            status: show.status,
            originalLanguage: show.originalLanguage,
            voteAverage: show.voteAverage,
            overview: show.overview
        )
        
        output?.displayShow(tvShow: viewModel)
    }
}
