//
//
//  Saveable.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/27.
//


import Foundation
import CoreData

protocol Saveable {
    func accept(visitor: SaveableVisitor)
}
