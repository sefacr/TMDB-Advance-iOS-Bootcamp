//
//  ShowDetailConfigurator.swift
//  MovieCleanSwift
//
//  Created by Seyfeddin Bassarac on 27.09.2025.
//

import Foundation

// MARK: - Connect View, Interactor and Presenter

extension ShowDetailInteractor: ShowDetailViewControllerOutput {}

extension ShowDetailPresenter: ShowDetailInteractorOutput {}

extension ShowDetailViewController: ShowDetailPresenterOutput {}

class ShowDetailConfigurator {
    
    static let shared = ShowDetailConfigurator()
    
    private init() {}
    
    func configure(viewController: ShowDetailViewController) {
        let presenter = ShowDetailPresenter()
        presenter.output = viewController
        
        let interactor = ShowDetailInteractor()
        interactor.output = presenter
        
        viewController.output = interactor
        let router = ShowDetailRouter()
        router.dataStore = interactor
        viewController.router = router
    }
}
