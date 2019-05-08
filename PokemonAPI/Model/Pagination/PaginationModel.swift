//
//  PaginationModel.swift
//  PokemonAPI
//
//  Created by Abraham Escamilla Pinelo on 5/6/19.
//  Copyright © 2019 AEP. All rights reserved.
//

import Foundation

struct PaginationModel: Codable {
    var count: Int = 0
    var next: String?
    var previous: String?
    
    init() {}
}

struct Pagination<T: Codable>: Codable {
    var results: [T]
    var count: Int = 0
    var next: String?
    var previous: String?
    
    init() {
        results = []
    }
}
