//
//  TVSeriesStore.swift
//  MovieMVC
//
//  Created by Seyfeddin Bassarac on 24.09.2025.
//

import UIKit

enum TVSeriesError: Error {
    case tvSeriesCreationError
}

class TVSeriesStore {
    var popularTvSeries: [TVSeries] = []
    var topRatedTvSeries: [TVSeries] = []
    
    var popularCurrentPage = 1
    var topRatedCurrentPage = 1
    
    var popularTotalPages = 1
    var topRatedTotalPages = 1
     
     private let session: URLSession = {
         let config = URLSessionConfiguration.default
         return URLSession(configuration: config)
     }()
    
    func fetchDetailedTVSeries(id: Int, completion: @escaping (Result<TVSeries, Error>) -> Void) {
        let request = TMDBAPI.detailsRequest(mediaType: .tv, id: id)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let jsonData = data {
                let result = TMDBAPI.detailedTVSeries(fromJSON: jsonData)
                DispatchQueue.main.async {
                    completion(result)
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(TVSeriesError.tvSeriesCreationError))
                }
            }
        }
        task.resume()
    }
     
    private func fetchTvSeries(endPoint: EndPoint, page: Int, completion: @escaping (Result<[TVSeries], Error>) -> Void) {
        let request = TMDBAPI.generalRequest(endPoint: endPoint, mediaType: .tv, page: page)
         let task = session.dataTask(with: request) {
             (data, response, error) in
             if let jsonData = data {
                 let result = TMDBAPI.tvSeries(fromJSON: jsonData)
                 
                 DispatchQueue.main.async {
                    if case .success(let (tvSeries, totalPages)) = result {
                         switch endPoint {
                         case .popular:
                            self.popularTvSeries.append(contentsOf: tvSeries)
                            self.popularTotalPages = totalPages
                         }
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
