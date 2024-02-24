//
//  PokemonRepository.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import Moya
import Combine
import CombineMoya

protocol PokemonRepositorySpec {
    func getPokemonList() -> AnyPublisher<PokemonListModel, Error>
}

final class PokemonRepository: PokemonRepositorySpec {
    
    private lazy var provider = MoyaProvider<PokemonAPITarget>()
    private lazy var jsonDecoder = JSONDecoder()
    
    func getPokemonList() -> AnyPublisher<PokemonListModel, Error> {
        return provider.requestPublisher(.getPokemonList).map(PokemonListEntity.self).map{ PokemonListModel(entity: $0) }.mapError{ $0 as Error }.eraseToAnyPublisher()
    }
}
