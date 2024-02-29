//
//  PokemonSpeciesModel.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/29.
//

import Foundation

class PokemonSpeciesModel {
    // "https://pokeapi.co/api/v2/evolution-chain/20/"
    let evolutionChainURL: String
    
    lazy var evolutionChainResourceID: String = {
        guard let lastPathComponent = URL(string: evolutionChainURL)?.lastPathComponent else {
            return evolutionChainURL
        }
        return lastPathComponent
    }()
    
    init(evolutionChainURL: String) {
        self.evolutionChainURL = evolutionChainURL
    }
}
