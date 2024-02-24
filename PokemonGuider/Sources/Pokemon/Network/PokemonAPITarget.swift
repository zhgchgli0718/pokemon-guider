//
//  Pokemon.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import Moya

enum PokemonAPITarget {
    case getPokemonList(String?)
    case getPokemonDetail(String)
}

extension PokemonAPITarget: TargetType {
    var baseURL: URL { APIServer.baseURL }
    var path: String {
        switch self {
        case .getPokemonList:
            return "/pokemon/"
        case .getPokemonDetail(let id):
            return "/pokemon/\(id)/"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getPokemonList, .getPokemonDetail:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .getPokemonList(let nextPage):
            var parameters: [String: String] = [:]
            if let nextPage = nextPage, let urlComponents = URLComponents(string: nextPage) {
                urlComponents.queryItems?.forEach({ queryItem in
                    parameters[queryItem.name] = queryItem.value
                })
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getPokemonDetail:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
