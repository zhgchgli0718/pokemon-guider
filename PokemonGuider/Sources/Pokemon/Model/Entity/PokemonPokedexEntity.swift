//
//  PokemonPokedexEntity.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/25.
//

import Foundation

struct PokemonPokedexEntity: Decodable {
    let descriptions: [Description]
}

extension PokemonPokedexEntity {
    struct Description: Decodable {
        struct Language: Decodable {
            let name: String
            let url: String
        }
        let description: String
        let language: Language
    }
}
