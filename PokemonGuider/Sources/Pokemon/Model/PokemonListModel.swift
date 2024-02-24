//
//  PokemonListModel.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation

final class PokemonListModel {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Item]
    
    var hasNext: Bool {
        return next != nil
    }

    init(entity: PokemonListEntity) {
        self.count = entity.count
        self.next = entity.next
        self.previous = entity.previous
        self.results = entity.results.map{ Item(name: $0.name, url: $0.url) }
    }
}

extension PokemonListModel {
    class Item {
        let name: String
        let url: String
        init(name: String, url: String) {
            self.name = name
            self.url = url
        }
    }
}
