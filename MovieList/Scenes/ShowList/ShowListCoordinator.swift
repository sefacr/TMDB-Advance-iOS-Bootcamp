//
//  ShowListCoordinator.swift
//  MovieList
//
//  Created by Sefa Acar on 30.01.2026.
//

import UIKit


final class ShowListCoordinator: Coordinator {
    
    enum ShowListChildCoordinators {
        case showDetail
    }
    
    weak var navigationController: UINavigationController!
    weak var mainViewController: ShowListViewController?
    private var childCoordinators: [ShowListChildCoordinators: Coordinator] = [:]
    
    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = ShowListBuilder.make()
        viewController.coordinator = self
        mainViewController = viewController
        if navigationController.viewControllers.isEmpty {
            navigationController.setViewControllers([viewController], animated: true)
        }
    }
    
    func handle(route: ShowListRoute) {
        switch route {
        case .detail(let viewModel):
            guard mainViewController != nil else {
                start()
                return
            }
            let showDetailCoordinator = ShowDetailCoordinator(
                navigationController: navigationController,
                viewModel: viewModel
            )
            showDetailCoordinator.finishDelegate = self
            childCoordinators[.showDetail] = showDetailCoordinator
            showDetailCoordinator.start()
        }
    }
}

extension ShowListCoordinator: ShowDetailCoordinatorFinishDelegate {
    func showDetailDidFinish() {
        childCoordinators.removeValue(forKey: .showDetail)
    }
}
