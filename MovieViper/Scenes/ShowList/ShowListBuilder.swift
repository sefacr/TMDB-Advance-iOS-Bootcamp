//
//  ShowListBuilder.swift
//  MovieViper
//
//  Created by Sefa Acar on 26.12.2025.
//

import UIKit

final class ShowListBuilder {
    
    static func make() -> ShowListViewController {
        
        let viewController = ShowListViewController()
        let service = ShowListService() // hiçbir dependencysi yok, o kendi içerisinde yapıyor zaten protokoller üzerinden haberleşiyor
        let interactor = ShowListInteractor(service: service)
        let presenter = ShowListPresenter(interactor: interactor, view: viewController)
        viewController.presenter = presenter
        //interactor delegate selfi presenter ancak presentter initte verdim, vermeseydim ve private değilse burada verecektim interactor.delegate = presenter gibi
        
        return viewController
    }
}
