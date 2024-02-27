//
//  PokemonPokedexModelMapping.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/27.
//

import Foundation

struct PokemonPokedexModelMapping {
    static func mapping(entity: PokemonPokedexEntity) -> PokemonPokedexModel {
        let descriptions = entity.descriptions.map { PokemonPokedexModel.Description(description: $0.description, language: .init(name: $0.language.name, url: $0.language.url)) }
        return PokemonPokedexModel(descriptions: descriptions)
    }
}
