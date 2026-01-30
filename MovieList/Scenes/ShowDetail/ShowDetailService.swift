//
//  ShowDetailService.swift
//  MovieList
//
//  Created by Sefa Acar on 29.01.2026.
//

import Foundation

protocol ShowDetailServiceProtocol: AnyObject {
    func fetchDetailedTVSeries(id: Int, completion: @escaping (Result<TVSeries, Error>) -> Void)
}

final class ShowDetailService: ShowDetailServiceProtocol {
    
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
    
}

enum TVSeriesError: Error {
    case tvSeriesCreationError
}
