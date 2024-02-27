//
//  PokemonDetailEntity.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/25.
//

import Foundation

struct PokemonDetailEntity: Decodable {
    let id: Int
    let name: String
    let types: [PokemonTypes]
    let sprites: Sprites
    let stats: [Stats]
}

extension PokemonDetailEntity {
    struct Sprites: Decodable {
        let back_default: String?
        let back_female: String?
        let back_shiny: String?
        let back_shiny_female: String?
        let front_default: String?
        let front_female: String?
        let front_shiny: String?
        let front_shiny_female: String?
    }
    struct PokemonTypes: Decodable {
        let type: PokemonType
        struct PokemonType: Decodable {
            let name: String
            let url: String
        }
    }
    struct Stats: Decodable {
        struct Stat: Decodable {
            let name: String
            let url: String
        }
        let base_stat: Int
        let effort: Int
        let stat: Stat
    }
}
