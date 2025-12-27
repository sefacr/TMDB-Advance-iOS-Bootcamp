//
//  ShowListCellPresentation.swift
//  MovieViper
//
//  Created by Sefa Acar on 28.12.2025.
//

import Foundation

// bunu struct yapma sebebim, burada ben sadece posterpath değiştirseydim class reference type olduğu için bütün presentation objesi değişmeyecekti, bunu didset ile cellde binding yapsaydım güncellenmeyecekti mesela ama struct value type old için herhangi bir değeri değiştiğinde önceki struct yerine bu eklenecekti.
struct ShowListCellPresentation {
    //poster celli configre etmek için bu iki parametreye ihtiyacım var
    var posterPath: String?
    var showBorder: Bool = true
    
    //ctrl+m ile sıralanabilir
    init(
        posterPath: String? = nil,
        showBorder: Bool = true
    ) {
        self.posterPath = posterPath
        self.showBorder = showBorder
    }
}
