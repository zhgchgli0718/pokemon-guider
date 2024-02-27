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
    
    init(count: Int, next: String?, previous: String?, results: [Item]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

extension PokemonListModel {
    class Item {
        let name: String
        let url: String
        let id: String
        init(name: String, url: String) {
            self.name = name
            self.url = url
            self.id = URL(string: url)?.lastPathComponent ?? url
        }
    }
}
