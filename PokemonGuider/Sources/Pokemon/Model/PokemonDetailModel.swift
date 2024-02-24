//
//  PokemonDetailModel.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/25.
//

import Foundation

final class PokemonDetailModel {
    let id: String
    let name: String
    let types: [PokemonType]
    let coverImage: String
    
    init(entity: PokemonDetailEntity) {
        self.id = String(entity.id)
        self.name = entity.name
        self.types = entity.types.map { PokemonType(name: $0.type.name, url: $0.type.url) }
        self.coverImage = entity.sprites.frontDefault
    }
}

extension PokemonDetailModel {
    class PokemonType {
        let name: String
        let url: String
        init(name: String, url: String) {
            self.name = name
            self.url = url
        }
    }
}
