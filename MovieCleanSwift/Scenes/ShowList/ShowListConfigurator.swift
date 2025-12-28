//
//  ShowListConfigurator.swift
//  MovieCleanSwift
//
//  Created by Seyfeddin Bassarac on 26.09.2025.
//

import Foundation

// MARK: - Connect View, Interactor and Presenter

extension ShowListInteractor: ShowListViewControllerOutput {}

extension ShowListPresenter: ShowListInteractorOutput {}

extension ShowListViewController: ShowListPresenterOutput {}

class ShowListConfigurator {
    
    static let shared = ShowListConfigurator()
    
    private init() {}
    
    func configure(viewController: ShowListViewController) {
        
        let presenter = ShowListPresenter()
        presenter.output = viewController
        
        let interactor = ShowListInteractor()
        interactor.output = presenter
        
        viewController.output = interactor

        let router = ShowListRouter()
        router.dataStore = interactor
        router.viewController = viewController
        viewController.router = router
    }
}
