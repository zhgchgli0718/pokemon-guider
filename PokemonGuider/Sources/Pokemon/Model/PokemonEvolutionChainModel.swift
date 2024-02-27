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
        
        init(name: String, url: String) {
            self.name = name
            self.url = url
        }
    }
}

