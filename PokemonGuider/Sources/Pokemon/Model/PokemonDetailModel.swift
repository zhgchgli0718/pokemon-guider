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
    let coverImage: String?
    let images: [String]
    let staus: [Stats]
    init(entity: PokemonDetailEntity) {
        self.id = String(entity.id)
        self.name = entity.name
        self.types = entity.types.map { PokemonType(name: $0.type.name, url: $0.type.url) }
        
        self.coverImage = entity.sprites.front_default
        self.images = [
            entity.sprites.back_default,
            entity.sprites.back_female,
            entity.sprites.back_shiny,
            entity.sprites.back_shiny_female,
            entity.sprites.front_default,
            entity.sprites.front_female,
            entity.sprites.front_shiny,
            entity.sprites.front_shiny_female
        ].compactMap { $0 }
        self.staus = entity.stats.map { Stats(base_stat: $0.base_stat, effort: $0.effort, stat: .init(name: $0.stat.name, url: $0.stat.url)) }
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
    
    class Stats: Decodable {
        class Stat: Decodable {
            let name: String
            let url: String
            init(name: String, url: String) {
                self.name = name
                self.url = url
            }
        }
        let base_stat: Int
        let effort: Int
        let stat: Stat
        init(base_stat: Int, effort: Int, stat: Stat) {
            self.base_stat = base_stat
            self.effort = effort
            self.stat = stat
        }
    }
}
