//
//  PokemonDetailViewModel.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/25.
//

import Foundation
import Combine

protocol PokemonDetailViewModelSpec {
    var id: String { get }
    func loadPokemonDetail() -> AnyPublisher<PokemonDetailModel, Error>
    func loadPokemonPokedex() -> AnyPublisher<PokemonPokedexModel, Error>
    func loadPokemonEvolutionChain() -> AnyPublisher<[PokemonDetailModel], Error>
    
    func isOwnedPokemon() -> Bool
    func ownPokemon(owned: Bool)
    func ownedPokemonChanges() -> AnyPublisher<PokemonDetailModel, Never>
}

final class PokemonDetailViewModel: PokemonDetailViewModelSpec {
    
    private var cancelBag = Set<AnyCancellable>()
    
    let id: String
    let useCase: PokemonUseCaseSpec
    init(id: String, useCase: PokemonUseCaseSpec = PokemonUseCase()) {
        self.id = id
        self.useCase = useCase
    }
    
    func loadPokemonDetail() -> AnyPublisher<PokemonDetailModel, Error> {
        return useCase.getPokemonDetail(id: id)
    }
    
    func loadPokemonPokedex() -> AnyPublisher<PokemonPokedexModel, Error> {
        return useCase.getPokemonPokedex(id: id)
    }
    
    func loadPokemonEvolutionChain() -> AnyPublisher<[PokemonDetailModel], Error> {
        return useCase.getPokemonEvolutionChain(id: id).flatMap { model in
            return model.chainNames.publisher.flatMap{ self.useCase.getPokemonDetail(name: $0) }.eraseToAnyPublisher()
        }.scan([], { accumulator, value in
            accumulator + [value]
        }).eraseToAnyPublisher()
    }
    
    func ownPokemon(owned: Bool) {
        useCase.ownPokemon(id: id, owned: owned)
    }
    
    func isOwnedPokemon() -> Bool {
        return useCase.isOwnedPokemon(id: id)
    }
    
    func ownedPokemonChanges() -> AnyPublisher<PokemonDetailModel, Never> {
        return useCase.ownedPokemonChanges().compactMap({ detailModel in
            guard self.id == detailModel.id else {
                return nil
            }
            return detailModel
        }).eraseToAnyPublisher()
    }
}