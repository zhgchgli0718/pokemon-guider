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
}
