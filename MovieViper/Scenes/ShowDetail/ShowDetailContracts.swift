//
//  ShowDetailContracts.swift
//  MovieViper
//
//  Created by Sefa Acar on 28.12.2025.
//

import Foundation

// MARK: - Presenter

// View Controller -> Presenter
protocol ShowDetailPresenterProtocol: AnyObject {
    func loadData()
}

enum ShowDetailPresenterOutput {
    case showTVSeries(TVSeries)
    case showLoading(Bool)
}

// MARK: - View

// Presenter -> View Controller
protocol ShowDetailViewProtocol: AnyObject {
    func handleOutput(_ output: ShowDetailPresenterOutput)
}

// MARK: - Interactor

// Presenter -> Interactor
protocol ShowDetailInteractorProtocol: AnyObject {
    var delegate: ShowDetailInteractorDelegate? { get set }
    func loadData()
}

enum ShowDetailInteractorOutput {
    case showLoading(Bool)
    case showTVSeries(TVSeries)
}

protocol ShowDetailInteractorDelegate: AnyObject {
    func handleOutput(_ output: ShowDetailInteractorOutput)
}
