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
import CoreData

protocol PokemonRepositorySpec {
    func getPokemonList(nextPage: String?) -> AnyPublisher<PokemonListModel, Error>
    func getPokemonDetail(id: String) -> AnyPublisher<PokemonDetailModel, Error>
    func getPokemonDetail(name: String) -> AnyPublisher<PokemonDetailModel, Error>
    func getPokemonPokedex(id: String) -> AnyPublisher<PokemonPokedexModel, Error>
    func getPokemonEvolutionChain(id: String) -> AnyPublisher<PokemonEvolutionChainModel, Error>
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
    
    func getPokemonDetail(name: String) -> AnyPublisher<PokemonDetailModel, Error> {
        return provider.requestPublisher(.getPokemonDetail(name)).map(PokemonDetailEntity.self).map{ PokemonDetailModel(entity: $0) }.mapError{ $0 as Error }.eraseToAnyPublisher()
    }
    
    func getPokemonPokedex(id: String) -> AnyPublisher<PokemonPokedexModel, Error> {
        return provider.requestPublisher(.getPokemonPokedex(id)).map(PokemonPokedexEntity.self).map{ PokemonPokedexModel(entity: $0) }.mapError{ $0 as Error }.eraseToAnyPublisher()
    }
    
    func getPokemonEvolutionChain(id: String) -> AnyPublisher<PokemonEvolutionChainModel, Error> {
        return provider.requestPublisher(.getPokemonEvolutionChain(id)).map(PokemonEvolutionChainEntity.self).map{ PokemonEvolutionChainModel(entity: $0) }.mapError{ $0 as Error }.eraseToAnyPublisher()
    }
}
