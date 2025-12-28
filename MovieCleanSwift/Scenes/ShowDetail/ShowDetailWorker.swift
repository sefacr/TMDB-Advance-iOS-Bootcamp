//
//  ShowDetailWorker.swift
//  MovieCleanSwift
//
//  Created by Seyfeddin Bassarac on 27.09.2025.
//

import Foundation

final class ShowDetailWorker {
    
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
