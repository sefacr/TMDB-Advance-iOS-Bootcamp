//
//  AppCoordinator.swift
//  MovieList
//
//  Created by Sefa Acar on 30.01.2026.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    enum AppChildCoordinators {
        case showList
    }
    
    let window: UIWindow
    private var childCoordinators: [AppChildCoordinators: Coordinator] = [:]
    let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        let showListCoordinator = ShowListCoordinator(navigationController: navigationController)
        childCoordinators[.showList] = showListCoordinator
        showListCoordinator.start()
    }
}

