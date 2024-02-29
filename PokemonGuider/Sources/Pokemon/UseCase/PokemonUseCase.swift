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
    func getPokemonEvolutionChain(id: String) -> AnyPublisher<[PokemonDetailModel], Error>
    
    func isOwnedPokemon(id: String) -> Bool
    func ownPokemon(id: String, owned: Bool)
    func ownedPokemonChanges() -> AnyPublisher<PokemonDetailModel, Never>
    func getAllOwnedPokemon() -> AnyPublisher<[PokemonDetailModel], Error>
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
        return repository.getPokemonList(nextPage: nextPage).flatMap { model in
            // 先從列表頁拿到所有 pokemon id
            // // pokemon id 分別去查 detail 拿到 name
            let publisher = model.results.map { self.getPokemonDetail(id: $0.id) }
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
    
    func getPokemonEvolutionChain(id: String) -> AnyPublisher<[PokemonDetailModel], Error> {
        // 需要先從 pokemon-species 拿到 evolution-chain id
        // 從 evolution-chain 拿到進化各階段的 pokemon name
        // pokemon name 分別去查 detail 拿到 name
        return repository.getPokemonSpecies(id: id).flatMap { speciesModel in
            return self.repository.getPokemonEvolutionChain(resourceID: speciesModel.evolutionChainResourceID).eraseToAnyPublisher()
        }.flatMap { evolutionChainModel in
            let publisher = evolutionChainModel.chainSpecies.sorted(by: { $0.order < $1.order }).map { self.getPokemonDetail(name: $0.name) }
            return Publishers.MergeMany(publisher).collect().eraseToAnyPublisher()
        }.eraseToAnyPublisher().eraseToAnyPublisher()
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
    
    func getAllOwnedPokemon() -> AnyPublisher<[PokemonDetailModel], Error> {
        return Just(self.coreDataRepository.getAllOwnedPokemon()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
