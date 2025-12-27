//
//  ShowListPresenter.swift
//  MovieViper
//
//  Created by Sefa Acar on 26.12.2025.
//

import Foundation

final class ShowListPresenter {
    
    //presenter protocolüne uymak zorunda
    //hem router hem interactorle haberleşir (router eklenecek)
    
    private let interactor: ShowListInteractorProtocol!
    private unowned let view: ShowListViewProtocol!
    //hem presenter viewla em de view presenterla haberleşiyor bu yüzden birisi weak olmalı
    
    private var tvSeries: [ShowListCellPresentation] = []
    
    init(
        interactor: ShowListInteractorProtocol!,
        view: ShowListViewProtocol!,
    ) {
        self.interactor = interactor
        self.view = view
        self.interactor.delegate = self
    }
}

extension ShowListPresenter: ShowListPresenterProtocol {
    
    var itemCount: Int {
        return tvSeries.count
    }
    
    func getPresentation(at index: Int) -> ShowListCellPresentation {
        return tvSeries[index]
    }
    
    func loadData() {
        interactor.loadData()
    }
}

extension ShowListPresenter: ShowListInteractorDelegate {
    
    func handleOutput(_ output: ShowListInteractorOutput) {
        switch output {
        case .showLoading(let isLoading):
            view.handleOutput(.showLoading(isLoading))
        case .showTVSeries(let tvSeries):
            let cellPresentations = tvSeries.map ({ShowListCellPresentation(posterPath: $0.posterPath)})
            self.tvSeries.append(contentsOf: cellPresentations)
            view.handleOutput(.showTVSeries(cellPresentations))
        }
    }
}
