//
//  ShowListViewModel.swift
//  MovieList
//
//  Created by Sefa Acar on 8.01.2026.
//

import Foundation

protocol ShowListViewModelProtocol: AnyObject {
    var delegate: ShowListViewModelDelegate? { get set }
    func loadData()
    func selectShow(at index: Int)
}

enum ShowListViewModelOutput {
    case displayShows([ShowListCellPresentation])
    case showLoading(Bool)
}

protocol ShowListViewModelDelegate: AnyObject {
    func handleOutput(_ output: ShowListViewModelOutput)
    func navigate(to route: ShowListRoute)
}

final class ShowListViewModel: ShowListViewModelProtocol {
    
//    var delegate: ShowListViewModelDelegate?
    var delegate: (any ShowListViewModelDelegate)? //swift 5.7 ile geldi
    
    private let service: ShowListServiceProtocol
    
    private var shows: [TVSeries] = []
    
    init(service: ShowListServiceProtocol) {
        self.service = service
    }
    
    func loadData() {
        delegate?.handleOutput(.showLoading(true))
        service.fetchPopularTvSeries { [weak self] result in
            guard let self else { return }
            delegate?.handleOutput(.showLoading(false))
            switch result {
            case .success(let tvSeries):
                self.shows.append(contentsOf: tvSeries)
                let cellPresentations: [ShowListCellPresentation] = self.shows.map(
                    { ShowListCellPresentation(tvShow: $0)}
                )
                delegate?.handleOutput(.displayShows(cellPresentations))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func selectShow(at index: Int) {
        let show = shows[index]
        delegate?.navigate(
            to: .detail(
                ShowDetailViewModel(
                    tvShow: show,
                    service: ShowDetailService()
                )
            )
        )
    }
    
    
}
