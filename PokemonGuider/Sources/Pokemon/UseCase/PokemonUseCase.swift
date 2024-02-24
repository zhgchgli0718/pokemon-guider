//
//  PokemonUseCase.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import Combine

protocol PokemonUseCaseSpec {
    func getPokemonList() -> AnyPublisher<PokemonListModel, Error>
}

final class PokemonUseCase: PokemonUseCaseSpec {
    
    let repository: PokemonRepositorySpec
    init(repository: PokemonRepositorySpec = PokemonRepository()) {
        self.repository = repository
    }
    
    func getPokemonList() -> AnyPublisher<PokemonListModel, Error> {
        return repository.getPokemonList()
    }
}
