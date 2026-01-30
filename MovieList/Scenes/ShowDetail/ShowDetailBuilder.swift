//
//  ShowDetailBuilder.swift
//  MovieList
//
//  Created by Sefa Acar on 29.01.2026.
//

import Foundation

final class ShowDetailBuilder {
    
    static func make(viewModel: ShowDetailViewModelProtocol) -> ShowDetailViewController {
        
        let viewController = ShowDetailViewController()
        viewController.viewModel = viewModel
        
        return viewController
    }
}
