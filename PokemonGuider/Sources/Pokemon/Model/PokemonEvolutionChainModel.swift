//
//  PokemonEvolutionChainModel.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/25.
//

import Foundation

final class PokemonEvolutionChainModel {
    
    let chainSpecies: [ChainSpecies]
    init(chainSpecies: [ChainSpecies]) {
        self.chainSpecies = chainSpecies
    }
}

extension PokemonEvolutionChainModel {
    class ChainSpecies {
        let name: String
        let url: String
        let order: Int
        
        init(name: String, url: String, order: Int) {
            self.name = name
            self.url = url
            self.order = order
        }
    }
}

