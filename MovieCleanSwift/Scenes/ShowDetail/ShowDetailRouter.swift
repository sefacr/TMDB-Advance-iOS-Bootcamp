//
//  ShowDetailRouter.swift
//  MovieCleanSwift
//
//  Created by Seyfeddin Bassarac on 27.09.2025.
//

import UIKit

protocol ShowDetailDataPassing {
    var dataStore: ShowDetailDataStore? { get }
}

class ShowDetailRouter: ShowDetailDataPassing {
    
    var dataStore: (any ShowDetailDataStore)?    
}
