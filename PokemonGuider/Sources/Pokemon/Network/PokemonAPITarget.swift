//
//  Pokemon.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import Moya

enum PokemonAPITarget {
    case getPokemonList
}

extension PokemonAPITarget: TargetType {
    var baseURL: URL { APIServer.baseURL }
    var path: String {
        switch self {
        case .getPokemonList:
            return "/pokemon"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getPokemonList:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .getPokemonList:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
