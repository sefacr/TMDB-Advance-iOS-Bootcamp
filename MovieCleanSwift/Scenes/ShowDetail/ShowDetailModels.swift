//
//  ShowDetailModels.swift
//  MovieCleanSwift
//
//  Created by Seyfeddin Bassarac on 27.09.2025.
//

import Foundation

struct ShowDetailRequest {}
struct ShowDetailResponse {
    var tvShow: TVSeries
}
struct ShowDetailViewModel {
    var id: Int
    var posterPath: String?
    var tagline: String?
    var name: String
    var originalName: String
    var firstAirDate: String?
    var status: String?
    var originalLanguage: String
    var voteAverage: Double
    var overview: String
}
