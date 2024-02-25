//
//  PokemonCellViewObject.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation

struct PokemonCellViewObject {
    let name: String
    let id: String
    let types: [String]
    var owned: Bool = false
    let coverImage: URL?
    
    init(item: PokemonListModel.Item) {
        self.name = item.name
        self.id = item.id
        self.types = []
        self.coverImage = nil
        self.owned = false
    }
    
    init(model: PokemonDetailModel) {
        self.name = model.name
        self.id = model.id
        self.types = model.types.map { $0.name }
        
        if let coverImage = model.coverImage {
            self.coverImage = URL(string: coverImage)
        } else {
            self.coverImage = nil
        }
    }
}
