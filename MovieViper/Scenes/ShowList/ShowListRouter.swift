//
//  ShowListRouter.swift
//  MovieViper
//
//  Created by Sefa Acar on 26.12.2025.
//

import UIKit

final class ShowListRouter: ShowListRouterProtocol {
    
    private unowned let view: UIViewController!
    
    init(view: UIViewController!) {
        self.view = view
    }
    
    func navigate(to route: ShowListRoute) {
        switch route {
        case .showTVDetails(let tvShow):
            let vc = UIViewController()
            self.view.show(vc, sender: nil)
            //show: navigation stackteyse pushlar değilse modal olarak gösterir
        }
    }
    
}
