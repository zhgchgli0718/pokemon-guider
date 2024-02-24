//
//  PokemonViewModel.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import Combine

protocol PokemonViewModelSpec {
    func loadPokemonList() -> AnyPublisher<PokemonListModel, Error>
}

final class PokemonViewModel: PokemonViewModelSpec {
    let useCase: PokemonUseCaseSpec
    init(useCase: PokemonUseCaseSpec = PokemonUseCase()) {
        self.useCase = useCase
    }
    
    func loadPokemonList() -> AnyPublisher<PokemonListModel, Error> {
        return useCase.getPokemonList()
    }
}
