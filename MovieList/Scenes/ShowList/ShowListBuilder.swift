//
//  ShowListBuilder.swift
//  MovieList
//
//  Created by Sefa Acar on 8.01.2026.
//

import Foundation

class ShowListBuilder {
    
    static func make() -> ShowListViewController {
        
        let viewController = ShowListViewController()
        let service = ShowListService()
        let viewModel = ShowListViewModel(service: service)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
