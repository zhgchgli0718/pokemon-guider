//
//
//  SaveableVisitor.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/27.
//

import Foundation

protocol SaveableVisitor {
    func visit(_ model: PokemonDetailModel)
}
