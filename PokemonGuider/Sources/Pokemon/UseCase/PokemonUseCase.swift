//
//  PokemonUseCase.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import Combine

protocol PokemonUseCaseSpec {
    func getPokemonList(nextPage: String?) -> AnyPublisher<(PokemonListModel, [PokemonDetailModel]), Error>
    func getPokemonDetail(id: String) -> AnyPublisher<PokemonDetailModel, Error>
    func getPokemonDetail(name: String) -> AnyPublisher<PokemonDetailModel, Error>
    func getPokemonPokedex(id: String) -> AnyPublisher<PokemonPokedexModel, Error>
    func getPokemonEvolutionChain(id: String) -> AnyPublisher<PokemonEvolutionChainModel, Error>
    
    func isOwnedPokemon(id: String) -> Bool
    func ownPokemon(id: String, owned: Bool)
    func ownedPokemonChanges() -> AnyPublisher<PokemonDetailModel, Never>
    func getAllOwnedPokemons() -> AnyPublisher<[PokemonDetailModel], Error>
}

final class PokemonUseCase: PokemonUseCaseSpec {

    let repository: PokemonRepositorySpec
    let coreDataRepository: CoreDataRespositorySpec
    
    init(repository: PokemonRepositorySpec = PokemonRepository(),
         coreDataRepository: CoreDataRespositorySpec = CoreDataRespository()) {
        self.repository = repository
        self.coreDataRepository = coreDataRepository
    }
    
    func getPokemonList(nextPage: String?) -> AnyPublisher<(PokemonListModel, [PokemonDetailModel]), Error> {
        // 優先從 Local 拿資料，入無再打 API
        return repository.getPokemonList(nextPage: nextPage).flatMap { model in
            let publisher = model.results.map { item in
                if let local = self.coreDataRepository.getPokemonDetail(id: item.id) {
                    return Just(local).setFailureType(to: Error.self).eraseToAnyPublisher()
                } else {
                    return self.getPokemonDetail(id: item.id)
                }
            }
            return Publishers.Zip(
                    Just(model).setFailureType(to: Error.self).eraseToAnyPublisher(),
                    Publishers.MergeMany(publisher).collect().eraseToAnyPublisher()
            ).eraseToAnyPublisher()
        }.eraseToAnyPublisher().eraseToAnyPublisher()
    }
    
    func getPokemonDetail(id: String) -> AnyPublisher<PokemonDetailModel, Error> {
        return repository.getPokemonDetail(id: id) .handleEvents(receiveOutput: { detailModel in
            self.coreDataRepository.savePokemon(detailModel)
        }).eraseToAnyPublisher()
    }
    
    func getPokemonDetail(name: String) -> AnyPublisher<PokemonDetailModel, Error> {
        return repository.getPokemonDetail(name: name).handleEvents(receiveOutput: { detailModel in
            self.coreDataRepository.savePokemon(detailModel)
        }).eraseToAnyPublisher()
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
        coreDataRepository.ownPokemon(id: id, owned: owned)
    }
    
    func ownedPokemonChanges() -> AnyPublisher<PokemonDetailModel, Never> {
        return coreDataRepository.ownedPokemonChanges()
    }
    
    func getAllOwnedPokemons() -> AnyPublisher<[PokemonDetailModel], Error> {
        return Future { result in
            result(.success(self.coreDataRepository.getAllOwnedPokemons()))
        }.eraseToAnyPublisher()
    }
}
