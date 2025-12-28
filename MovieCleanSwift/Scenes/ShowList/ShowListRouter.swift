//
//  ShowListRouter.swift
//  MovieCleanSwift
//
//  Created by Seyfeddin Bassarac on 27.09.2025.
//

import UIKit

protocol ShowListRouterInput {
    func routeToShowDetail(segue: UIStoryboardSegue?)
}

protocol ShowListDataPassing {
    var dataStore: ShowListDataStore? { get }
}

class ShowListRouter: ShowListRouterInput, ShowListDataPassing {
    weak var viewController: ShowListViewController?
    var dataStore: ShowListDataStore?
    
    func routeToShowDetail(segue: UIStoryboardSegue?) {
        if let segue {
            let destinationVC = segue.destination as! ShowDetailViewController
            var destinationDataStore = destinationVC.router!.dataStore!
            passDataToShowDetail(source: dataStore!, destination: &destinationDataStore)
            navigateToShowDetail(source: viewController!, destination: destinationVC)
        } else {
            let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
                withIdentifier: "ShowDetailViewController"
            ) as! ShowDetailViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowDetail(source: dataStore!, destination: &destinationDS)
            navigateToShowDetail(source: viewController!, destination: destinationVC)
        }
    }
    
    func navigateToShowDetail(source: ShowListViewController, destination: ShowDetailViewController)
    {
      source.show(destination, sender: nil)
    }
    
    func passDataToShowDetail(source: ShowListDataStore, destination: inout ShowDetailDataStore) {
        let selectedItem = viewController?.mainCollectionView.indexPathsForSelectedItems?.first?.item
        destination.tvShow = source.shows?[selectedItem!]
    }
}
