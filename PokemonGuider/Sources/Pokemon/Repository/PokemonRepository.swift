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
    func getPokemonSpecies(id: String) -> AnyPublisher<PokemonSpeciesModel, Error>
    func getPokemonEvolutionChain(resourceID: String) -> AnyPublisher<PokemonEvolutionChainModel, Error>
}

final class PokemonRepository: PokemonRepositorySpec {

    private let provider: MoyaProvider<PokemonAPITarget>
    private lazy var jsonDecoder = JSONDecoder()
    
    init(provider: MoyaProvider<PokemonAPITarget> =  MoyaProvider<PokemonAPITarget>()) {
        self.provider = provider
    }
    
    func getPokemonList(nextPage: String?) -> AnyPublisher<PokemonListModel, Error> {
        return provider.requestPublisher(.getPokemonList(nextPage)).map(PokemonListEntity.self).map{ PokemonListModelMapping.mapping(entity: $0) }.mapError{ $0 as Error }.eraseToAnyPublisher()
    }
    
    func getPokemonDetail(id: String) -> AnyPublisher<PokemonDetailModel, Error> {
        return provider.requestPublisher(.getPokemonDetail(id)).map(PokemonDetailEntity.self).map{ PokemonDetailModelMapping.mapping(entity: $0) }.mapError{ $0 as Error }.eraseToAnyPublisher()
    }
    
    func getPokemonDetail(name: String) -> AnyPublisher<PokemonDetailModel, Error> {
        return provider.requestPublisher(.getPokemonDetail(name)).map(PokemonDetailEntity.self).map{ PokemonDetailModelMapping.mapping(entity: $0) }.mapError{ $0 as Error }.eraseToAnyPublisher()
    }
    
    func getPokemonPokedex(id: String) -> AnyPublisher<PokemonPokedexModel, Error> {
        return provider.requestPublisher(.getPokemonPokedex(id)).map(PokemonPokedexEntity.self).map{ PokemonPokedexModelMapping.mapping(entity: $0) }.mapError{ $0 as Error }.eraseToAnyPublisher()
    }
    
    func getPokemonSpecies(id: String) -> AnyPublisher<PokemonSpeciesModel, Error> {
        return provider.requestPublisher(.getPokemonSpecies(id)).map(PokemonSpeciesEntity.self).map { PokemonSpeciesModelMapping.mapping(entity: $0) }.mapError { $0 as Error }.eraseToAnyPublisher()
    }
    
    func getPokemonEvolutionChain(resourceID: String) -> AnyPublisher<PokemonEvolutionChainModel, Error> {
        return provider.requestPublisher(.getPokemonEvolutionChain(resourceID)).map(PokemonEvolutionChainEntity.self).map{ PokemonEvolutionChainModelMapping.mapping(entity: $0) }.mapError { $0 as Error }.eraseToAnyPublisher()
    }
}
