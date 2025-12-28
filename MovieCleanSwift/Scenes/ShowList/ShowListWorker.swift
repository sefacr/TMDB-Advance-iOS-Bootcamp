//
//  ShowListWorker.swift
//  MovieCleanSwift
//
//  Created by Seyfeddin Bassarac on 26.09.2025.
//

import Foundation

enum TVSeriesError: Error {
    case tvSeriesCreationError
}

class ShowListWorker {
    
    var currentPage: Int {
        return popularCurrentPage
    }
    
    var popularCurrentPage = 1
    
    var popularTotalPages = 1
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    private func fetchTvSeries(endPoint: EndPoint, page: Int, completion: @escaping (Result<[TVSeries], Error>) -> Void) {
        let request = TMDBAPI.generalRequest(endPoint: endPoint, mediaType: .tv, page: page)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let jsonData = data {
                let result = TMDBAPI.tvSeries(fromJSON: jsonData)
                
                DispatchQueue.main.async {
                    if case .success(let (tvSeries, totalPages)) = result {
                        self.popularTotalPages = totalPages
                        completion(.success(tvSeries))
                    } else if case .failure(let error) = result {
                        completion(.failure(error))
                    }
                }
            } else if let requestError = error {
                DispatchQueue.main.async {
                    completion(.failure(requestError))
                }
                print("Error fetching tv series: \(requestError)")
            } else {
                DispatchQueue.main.async {
                    completion(.failure(TVSeriesError.tvSeriesCreationError))
                }
                print("Unexpected error with the request")
            }
        }
        task.resume()
    }
    
    func fetchPopularTvSeries(completion: @escaping (Result<[TVSeries], Error>) -> Void) {
        guard popularCurrentPage <= popularTotalPages else { return }
        
        fetchTvSeries(endPoint: .popular, page: popularCurrentPage) { [weak self] result in
            switch result {
            case .success(let tvSeries):
                self?.popularCurrentPage += 1
                completion(.success(tvSeries))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

