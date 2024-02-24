//
//  PokemonListEntity.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation

struct PokemonListEntity: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Item]
}

extension PokemonListEntity {
    struct Item: Decodable {
        let name: String
        let url: String
    }
}
