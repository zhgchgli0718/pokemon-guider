//
//  PokemonSpeciesModelMapping.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/29.
//

import Foundation

struct PokemonSpeciesModelMapping {
    static func mapping(entity: PokemonSpeciesEntity) -> PokemonSpeciesModel {
        return PokemonSpeciesModel(evolutionChainURL: entity.evolution_chain.url)
    }
}
