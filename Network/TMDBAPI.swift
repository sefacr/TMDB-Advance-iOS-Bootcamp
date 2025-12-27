//
//  EndPoint.swift
//  MovieMVC
//
//  Created by Seyfeddin Bassarac on 24.09.2025.
//

import Foundation

struct TokenStorage {
    static var accessToken: String {
        return "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1MjZhYTVjZmNiYzUyY2EyOTA1YWIyY2Q0ZjdjZTg1YSIsIm5iZiI6MTc2NTk1ODk2Ny4wNiwic3ViIjoiNjk0MjY1MzdjZDg4ZGJkMTAzZDczOGIyIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.ue2tK25K4KPtRILfLaR4ym6CtZuVFJuurM0le8Wil6E"
    }
}

enum EndPoint: String {
    case popular = "popular"
}

enum HTTPMethod: String {
    case get, post, delete
    
    var methodString: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .get:
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(TokenStorage.accessToken)"
            ]
        case .post, .delete:
            return [
                "accept": "application/json",
                "Content-Type": "application/json;charset=utf-8",
                "Authorization": "Bearer \(TokenStorage.accessToken)"
            ]
        }
    }
}

enum RequestLanguage: String {
    case en = "en-US"
    case tr = "tr-TR"
}

struct TMDBAPI {
    private static let baseURLString = "https://api.themoviedb.org/3"
    private static let apiKey = TokenStorage.accessToken
    
    struct TMDBResponse<T: Decodable>: Decodable {
        let page: Int
        let results: [T]
        let totalPages: Int
        let totalResults: Int
        
        enum CodingKeys: String, CodingKey {
            case page, results
            case totalPages = "total_pages"
            case totalResults = "total_results"
        }
    }
    
    static func generalRequest(
        endPoint: EndPoint,
        mediaType: MediaType? = nil,
        language: RequestLanguage = .en,
        page: Int = 1,
        method: HTTPMethod = .get,
        parameters: [String:String]? = nil
    ) -> URLRequest {
        
        var urlString = "\(baseURLString)/\(endPoint.rawValue)"
        if let mediaType = mediaType {
            urlString = "\(baseURLString)/\(mediaType.rawValue)/\(endPoint.rawValue)"
        }
        
        let fullurl = URL(string: urlString)!
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: language.rawValue),
            URLQueryItem(name: "page", value: String(page)),
        ]
        
        if let parameters = parameters {
            for(key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        }
        
        var components = URLComponents(url: fullurl, resolvingAgainstBaseURL: true)!
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.methodString
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = method.headers
        
        return request
    }
    
    static func tvSeries(fromJSON data: Data) -> Result<([TVSeries], Int), Error> {
        return decodeResponse(from: data)
    }
    
    private static func decodeResponse<T: Codable>(from data: Data) -> Result<([T], Int), Error> {
        do {
            let decoder = JSONDecoder()
            let tmdbResponse = try decoder.decode(TMDBResponse<T>.self, from: data)
            return .success((tmdbResponse.results, tmdbResponse.totalPages))
        } catch {
            return .failure(error)
        }
    }
    
    static func detailsRequest(
        mediaType: MediaType,
        id: Int,
        language: RequestLanguage = .en,
        method: HTTPMethod = .get,
        parameters: [String:String]? = nil
    ) -> URLRequest {
        
        let urlString = "\(baseURLString)/\(mediaType.rawValue)/\(id)"
        
        let fullurl = URL(string: urlString)!
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: language.rawValue)
        ]
        
        if let parameters = parameters {
            for(key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        }
        
        var components = URLComponents(url: fullurl, resolvingAgainstBaseURL: true)!
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.methodString
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = method.headers
        
        return request
    }
    
    static func detailedTVSeries(fromJSON data: Data) -> Result<TVSeries, Error> {
        do {
            let decoder = JSONDecoder()
            let tvSerie = try decoder.decode(TVSeries.self, from: data)
            return .success(tvSerie)
        } catch {
            return .failure(error)
        }
    }
}
