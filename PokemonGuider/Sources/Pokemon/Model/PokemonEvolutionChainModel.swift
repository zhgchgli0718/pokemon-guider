//
//  PokemonEvolutionChainModel.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/25.
//

import Foundation

final class PokemonEvolutionChainModel {
    
    let chain: Chain
    var chainNames: [String] {
        var chainNames: [String] = []
        var chain: Chain? = self.chain
        while let thisChain = chain {
            chainNames.append(thisChain.species.name)
            chain = thisChain.evolves_to.first
        }
        return chainNames
    }
    
    init(entity: PokemonEvolutionChainEntity) {
        chain = Chain(entity: entity.chain)
    }
}

extension PokemonEvolutionChainModel {
    class Chain {
        class Species {
            let name: String
            let url: String
            
            init(entity: PokemonEvolutionChainEntity.Chain.Species) {
                self.name = entity.name
                self.url = entity.url
            }
        }
        
        let evolves_to: [Chain]
        let species: Species
        
        init(entity: PokemonEvolutionChainEntity.Chain) {
            self.evolves_to = entity.evolves_to.map { Chain(entity: $0) }
            self.species = Species(entity: entity.species)
        }
    }
}

