//
//  PokemonUseCase.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import Combine

protocol PokemonUseCaseSpec {
    func getPokemonList(nextPage: String?) -> AnyPublisher<PokemonListModel, Error>
    func getPokemonDetail(id: String) -> AnyPublisher<PokemonDetailModel, Error>
    func getPokemonDetail(name: String) -> AnyPublisher<PokemonDetailModel, Error>
    func getPokemonPokedex(id: String) -> AnyPublisher<PokemonPokedexModel, Error>
    func getPokemonEvolutionChain(id: String) -> AnyPublisher<PokemonEvolutionChainModel, Error>
}

final class PokemonUseCase: PokemonUseCaseSpec {

    let repository: PokemonRepositorySpec
    init(repository: PokemonRepositorySpec = PokemonRepository()) {
        self.repository = repository
    }
    
    func getPokemonList(nextPage: String?) -> AnyPublisher<PokemonListModel, Error> {
        return repository.getPokemonList(nextPage: nextPage)
    }
    
    func getPokemonDetail(id: String) -> AnyPublisher<PokemonDetailModel, Error> {
        return repository.getPokemonDetail(id: id)
    }
    
    func getPokemonDetail(name: String) -> AnyPublisher<PokemonDetailModel, Error> {
        return repository.getPokemonDetail(name: name)
    }
    
    func getPokemonPokedex(id: String) -> AnyPublisher<PokemonPokedexModel, Error> {
        return repository.getPokemonPokedex(id: id)
    }
    
    func getPokemonEvolutionChain(id: String) -> AnyPublisher<PokemonEvolutionChainModel, Error> {
        return repository.getPokemonEvolutionChain(id: id)
    }
}
