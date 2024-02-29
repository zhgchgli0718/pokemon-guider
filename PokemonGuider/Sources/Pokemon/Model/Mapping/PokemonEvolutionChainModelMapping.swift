//
//  PokemonEvolutionChainModelMapping.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/27.
//

import Foundation

struct PokemonEvolutionChainModelMapping {
    static func mapping(entity: PokemonEvolutionChainEntity) -> PokemonEvolutionChainModel {
        var chain: PokemonEvolutionChainEntity.Chain? = entity.chain
        var chainSpecies: [PokemonEvolutionChainModel.ChainSpecies] = []
        while let thisChain = chain {
            chainSpecies.append(.init(name: thisChain.species.name, url: thisChain.species.url, order: chainSpecies.count))
            chain = thisChain.evolves_to.first
        }
        
        return PokemonEvolutionChainModel(chainSpecies: chainSpecies)
    }
}
