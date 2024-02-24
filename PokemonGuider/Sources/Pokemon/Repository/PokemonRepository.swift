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
    func getPokemonList(nextPage: String?) -> AnyPublisher<PokemonListModel, Error>
    func getPokemonDetail(id: String) -> AnyPublisher<PokemonDetailModel, Error>
}

final class PokemonRepository: PokemonRepositorySpec {

    private lazy var provider = MoyaProvider<PokemonAPITarget>()
    private lazy var jsonDecoder = JSONDecoder()
    
    func getPokemonList(nextPage: String?) -> AnyPublisher<PokemonListModel, Error> {
        return provider.requestPublisher(.getPokemonList(nextPage)).map(PokemonListEntity.self).map{ PokemonListModel(entity: $0) }.mapError{ $0 as Error }.eraseToAnyPublisher()
    }
    
    func getPokemonDetail(id: String) -> AnyPublisher<PokemonDetailModel, Error> {
        return provider.requestPublisher(.getPokemonDetail(id)).map(PokemonDetailEntity.self).map{ PokemonDetailModel(entity: $0) }.mapError{ $0 as Error }.eraseToAnyPublisher()
    }
}
