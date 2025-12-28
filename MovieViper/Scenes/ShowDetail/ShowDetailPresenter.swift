//
//  ShowDetailPresenter.swift
//  MovieViper
//
//  Created by Sefa Acar on 28.12.2025.
//

import Foundation

final class ShowDetailPresenter: ShowDetailPresenterProtocol, ShowDetailInteractorDelegate {
    
    private var interactor: ShowDetailInteractorProtocol!
    private unowned let view: ShowDetailViewProtocol!
    
    init(
        interactor: ShowDetailInteractorProtocol!,
        view: ShowDetailViewProtocol!
    ) {
        self.interactor = interactor
        self.view = view
        self.interactor.delegate = self
    }
    
    func loadData() {
        interactor.loadData()
    }
    
    func handleOutput(_ output: ShowDetailInteractorOutput) {
        switch output {
        case .showTVSeries(let serie):
            view.handleOutput(.showTVSeries(serie))
        case .showLoading(let isLoading):
            view.handleOutput(.showLoading(isLoading))
        }
    }
}
