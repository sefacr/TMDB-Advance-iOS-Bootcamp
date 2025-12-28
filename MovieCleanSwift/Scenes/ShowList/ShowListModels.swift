//
//  ShowListModels.swift
//  MovieCleanSwift
//
//  Created by Seyfeddin Bassarac on 26.09.2025.
//

import Foundation

struct ShowListRequest {}

struct ShowListResponse {
    var shows: [TVSeries]
}

struct ShowListViewModel {
    
    var id: Int
    var posterPath: String?
    var showBorder: Bool = true
    
    init(
        id: Int,
        posterPath: String? = nil,
        showBorder: Bool = true
    ) {
        self.id = id
        self.posterPath = posterPath
        self.showBorder = showBorder
    }
}
