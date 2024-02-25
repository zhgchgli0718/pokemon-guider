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
    
    func isOwnedPokemon(id: String) -> Bool
    func ownPokemon(id: String, owned: Bool)
    func ownedPokemonChanges() -> AnyPublisher<(String, Bool), Never>
    func getAllOwnedPokemons() -> AnyPublisher<PokemonListModel, Error>
}

final class PokemonUseCase: PokemonUseCaseSpec {

    let repository: PokemonRepositorySpec
    let coreDataRepository: CoreDataRespositorySpec
    
    init(repository: PokemonRepositorySpec = PokemonRepository(),
         coreDataRepository: CoreDataRespositorySpec = CoreDataRespository()) {
        self.repository = repository
        self.coreDataRepository = coreDataRepository
    }
    
    func getPokemonList(nextPage: String?) -> AnyPublisher<PokemonListModel, Error> {
        return repository.getPokemonList(nextPage: nextPage).eraseToAnyPublisher()
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
    
    func isOwnedPokemon(id: String) -> Bool {
        return coreDataRepository.isOwnedPokemon(id: id)
    }
    
    func ownPokemon(id: String, owned: Bool) {
        coreDataRepository.savePokemon(id: id, name: nil, owned: owned)
    }
    
    func ownedPokemonChanges() -> AnyPublisher<(String, Bool), Never> {
        return coreDataRepository.ownedPokemonChanges()
    }
    
    func getAllOwnedPokemons() -> AnyPublisher<PokemonListModel, Error> {
        return Future { result in
            result(.success(self.coreDataRepository.getAllOwnedPokemons()))
        }.eraseToAnyPublisher()
    }
}
