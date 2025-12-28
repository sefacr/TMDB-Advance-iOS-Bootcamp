//
//  ShowListContracts.swift
//  MovieViper
//
//  Created by Sefa Acar on 26.12.2025.
//

import Foundation

// MARK: - Router

enum ShowListRoute {
    case showTVDetails(TVSeries)
}

protocol ShowListRouterProtocol: AnyObject {
    func navigate(to route: ShowListRoute)
}

// MARK: - Presenter

// View Controller -> Presenter
protocol ShowListPresenterProtocol: AnyObject {
    var itemCount: Int { get }
    func getPresentation(at index: Int) -> ShowListCellPresentation
    func loadData()
    func selectTVSeries(at index: Int)
}

enum ShowListPresenterOutput {
    case showTVSeries([ShowListCellPresentation])
    case showLoading(Bool)
}

// MARK: - View

// Presenter -> View Controller
protocol ShowListViewProtocol: AnyObject {
    func handleOutput(_ output: ShowListPresenterOutput)
}

// MARK: - Interactor

// Presenter -> Interactor
protocol ShowListInteractorProtocol: AnyObject {
    var delegate: ShowListInteractorDelegate? { get set }
    func loadData()
    func selectTVSeries(_ index: Int)
}

enum ShowListInteractorOutput {
    case showLoading(Bool)
    case showTVSeries([TVSeries])
    case selectTVSerie(TVSeries)
}

//call back kullanmıyorsak bu datayı geri delegate ile döncez, genellikle tercih edilen delegate
protocol ShowListInteractorDelegate: AnyObject {
    func handleOutput(_ output: ShowListInteractorOutput)
}
