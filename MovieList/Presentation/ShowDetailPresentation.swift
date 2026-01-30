//
//  ShowDetailPresentation.swift
//  MovieList
//
//  Created by Sefa Acar on 30.01.2026.
//

import Foundation

struct ShowDetailPresentation {
    
    var id: Int
    var posterPath: String?
    var tagline: String?
    var name: String
    var originalName: String
    
    var releaseDateText: String?
    var languageText: String?
    var genresText: String?
    var statusText: String?
    var voteAverageText: String?
    var overviewText: String?
    
    init(with tvShow: TVSeries) {
        self.id = tvShow.id
        self.posterPath = tvShow.posterPath
        self.tagline = tvShow.tagline
        self.name = tvShow.name
        self.originalName = tvShow.originalName
        self.releaseDateText = "First Air Date: \(tvShow.firstAirDate ?? "N/A")"
        self.statusText = "Status: \(tvShow.status ?? "Unknown")"
        self.languageText = "Original Language: \(tvShow.originalLanguage.uppercased())"
        self.voteAverageText = "Rating: \(String(format: "%.1f", tvShow.voteAverage))"
        self.overviewText = tvShow.overview
        let genresText = (tvShow.genres ?? []).compactMap({ $0.name }).joined(separator: ", ")
        self.genresText = genresText.isEmpty ? "N/A" : genresText
    }
}
