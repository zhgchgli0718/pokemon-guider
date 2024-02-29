//
//  PokemonSpeciesEntity.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/29.
//

import Foundation

struct PokemonSpeciesEntity: Decodable {
    let evolution_chain: EvolutionChain
}

extension PokemonSpeciesEntity {
    struct EvolutionChain: Decodable {
        let url: String
    }
}
