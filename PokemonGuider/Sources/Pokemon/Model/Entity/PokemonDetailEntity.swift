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
}

extension PokemonDetailEntity {
    struct Sprites: Decodable {
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
        let frontDefault: String
    }
    struct PokemonTypes: Decodable {
        let type: PokemonType
        struct PokemonType: Decodable {
            let name: String
            let url: String
        }
    }
}
