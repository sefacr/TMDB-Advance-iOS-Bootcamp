//
//  ShowDetailBuilder.swift
//  MovieViper
//
//  Created by Sefa Acar on 28.12.2025.
//

import Foundation

final class ShowDetailBuilder {
    
    static func make(tvSerie: TVSeries) -> ShowDetailViewController {
        let viewController = ShowDetailViewController()
        
        let interactor = ShowDetailInteractor(tvShow: tvSerie, service: ShowDetailService())
        let presenter = ShowDetailPresenter(interactor: interactor, view: viewController)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
