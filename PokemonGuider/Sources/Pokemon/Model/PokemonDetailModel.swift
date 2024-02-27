//
//  PokemonDetailModel.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/25.
//

import Foundation
import CoreData

final class PokemonDetailModel {
    let id: String
    let name: String
    let types: [PokemonType]
    let coverImage: String?
    let images: [String]
    let stats: [Stat]
    var owned: Bool?
    
    init(id: String, name: String, types: [PokemonType], coverImage: String?, images: [String], stats: [Stat], owned: Bool?) {
        self.id = id
        self.name = name
        self.types = types
        self.coverImage = coverImage
        self.images = images
        self.stats = stats
        self.owned = owned
    }
}

extension PokemonDetailModel: Saveable {
    func accept(visitor: SaveableVisitor) {
        visitor.visit(self)
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
    
    class Stat: Decodable {
        let name: String
        let url: String
        let baseStat: Int
        let effort: Int
        init(name: String, url: String, baseStat: Int, effort: Int) {
            self.name = name
            self.url = url
            self.baseStat = baseStat
            self.effort = effort
        }
    }
}
