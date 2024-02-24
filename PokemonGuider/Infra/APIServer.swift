//
//  APIServer.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation

final class APIServer {
    static let baseURL = {
        return URL(string: "https://pokeapi.co/api/v2")!
    }()
}
