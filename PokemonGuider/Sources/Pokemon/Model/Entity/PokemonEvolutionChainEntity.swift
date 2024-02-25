//
//  PokemonEvolutionChainEntity.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/25.
//

import Foundation

struct PokemonEvolutionChainEntity: Decodable {
    let chain: Chain
}

extension PokemonEvolutionChainEntity {
    class Chain: Decodable {
        struct Species: Decodable {
            let name: String
            let url: String
        }
        
        let evolves_to: [Chain]
        let species: Species
    }
}
