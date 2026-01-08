//
//  ShowListService.swift
//  MovieList
//
//  Created by Sefa Acar on 8.01.2026.
//

import Foundation

protocol ShowListServiceProtocol: AnyObject {
    func fetchPopularTvSeries(completion: @escaping (Result<[TVSeries], Error>) -> Void)
}

final class ShowListService: ShowListServiceProtocol {
    
    var popularCurrentPage = 1
    var popularTotalPages = 1
     
     private let session: URLSession = {
         let config = URLSessionConfiguration.default
         return URLSession(configuration: config)
     }()
    
    func fetchPopularTvSeries(completion: @escaping (Result<[TVSeries], any Error>) -> Void) {
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
}
