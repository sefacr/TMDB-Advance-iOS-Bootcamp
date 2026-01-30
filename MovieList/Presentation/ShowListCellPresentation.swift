//
//  ShowListCellPresentation.swift
//  MovieList
//
//  Created by Sefa Acar on 30.01.2026.
//

import Foundation

struct ShowListCellPresentation {
    
    var posterPath: String?
    var showBorder: Bool = true
    
    init(
        posterPath: String? = nil,
        showBorder: Bool = true
    ) {
        self.posterPath = posterPath
        self.showBorder = showBorder
    }
    
    init(
        tvShow: TVSeries
    ) {
        self.posterPath = tvShow.posterPath
        self.showBorder = true
    }
    
}
