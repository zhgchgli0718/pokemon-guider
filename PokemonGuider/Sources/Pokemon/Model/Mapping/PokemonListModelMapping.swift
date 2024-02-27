//
//  PokemonListModelMapping.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/27.
//

import Foundation

struct PokemonListModelMapping {
    static func mapping(entity: PokemonListEntity) -> PokemonListModel {
        let items = entity.results.map{ PokemonListModel.Item(name: $0.name, url: $0.url) }
        return PokemonListModel(count: entity.count, next: entity.next, previous: entity.previous, results: items)
    }
}
