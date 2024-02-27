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
    
    init(model: PokemonDetailModel) {
        self.name = model.name
        self.owned = model.owned
        self.id = model.id
        self.types = model.types.map { $0.name }
        
        if let coverImage = model.coverImage {
            self.coverImage = URL(string: coverImage)
        } else {
            self.coverImage = nil
        }
    }
}
