//
//  ContentID.swift
//  MovieMVC
//
//  Created by Seyfeddin Bassarac on 24.09.2025.
//


struct ContentID: Codable {
    let id: Int
    let mediaType: String
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct GenresResponse: Codable {
    let genres: [Genre]
}
