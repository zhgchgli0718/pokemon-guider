//
//  PokemonRepositoryTests.swift
//  PokemonGuiderTests
//
//  Created by zhgchgli on 2024/2/28.
//

import XCTest
@testable import PokemonGuider
import Combine
import CombineMoya
import Moya

final class PokemonRepositoryTests: XCTestCase {
    
    private var cancelBag = Set<AnyCancellable>()
    
    func testGetPokemonList() {
        let expectation = expectation(description: "getPokemonList expectation")
        let pokemonRepository = PokemonRepository(provider: makeStubMoyaProvider())
        pokemonRepository.getPokemonList(nextPage: nil).sink { result in
            //
        } receiveValue: { listModel in
            XCTAssertEqual(listModel.count, 999)
            XCTAssertEqual(listModel.previous, "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=20")
            XCTAssertEqual(listModel.next, "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20")
            XCTAssertEqual(listModel.results.count, 20)
            expectation.fulfill()
        }.store(in: &cancelBag)
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testGetPokemonPokedex() {
        let expectation = expectation(description: "getPokemonPokedex expectation")
        let pokemonRepository = PokemonRepository(provider: makeStubMoyaProvider())
        pokemonRepository.getPokemonPokedex(id: "1").sink { _ in
            //
        } receiveValue: { pokedexModel in
            XCTAssertEqual(pokedexModel.descriptions.count, 4)
            XCTAssertEqual(pokedexModel.currentLanguageDescription?.description, "Entire National dex")
            expectation.fulfill()
        }.store(in: &cancelBag)
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testGetPokemonSpecies() {
        let expectation = expectation(description: "testGetPokemonSpecies expectation")
        let pokemonRepository = PokemonRepository(provider: makeStubMoyaProvider())
        pokemonRepository.getPokemonSpecies(id: "1").sink { _ in
           //
        } receiveValue: { chainSpeciesModel in
            XCTAssertEqual(chainSpeciesModel.evolutionChainURL, "https://pokeapi.co/api/v2/evolution-chain/1/")
            expectation.fulfill()
        }.store(in: &cancelBag)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetPokemonEvolutionChain() {
        let expectation = expectation(description: "getPokemonEvolutionChain expectation")
        let pokemonRepository = PokemonRepository(provider: makeStubMoyaProvider())
        pokemonRepository.getPokemonEvolutionChain(resourceID: "1").sink { _ in
           //
        } receiveValue: { evolutionChainModel in
            XCTAssertEqual(evolutionChainModel.chainSpecies.count, 3)
            XCTAssertEqual(evolutionChainModel.chainSpecies.first!.name, "bulbasaur")
            expectation.fulfill()
        }.store(in: &cancelBag)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
}

private extension PokemonRepositoryTests {
    func makeStubMoyaProvider() -> MoyaProvider<PokemonAPITarget> {
        let stubEndpointClosure = { (target: PokemonAPITarget) -> Endpoint in
            let data: Data
            switch target {
            case .getPokemonDetail:
                data = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "pokemonDetail", withExtension: "json")!)
            case .getPokemonList(_):
                data = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "pokemonList", withExtension: "json")!)
            case .getPokemonSpecies:
                data = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "pokemonSpecies", withExtension: "json")!)
            case .getPokemonPokedex:
                data = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "pokemonPokedex", withExtension: "json")!)
            case .getPokemonEvolutionChain:
                data = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "pokemonEvolutionChain", withExtension: "json")!)
            }
          return Endpoint(url: URL(target: target).absoluteString,
                          sampleResponseClosure: { .networkResponse(500 , data) },
                          method: target.method,
                          task: target.task,
                          httpHeaderFields: target.headers)
        }
        let stubbingProvider = MoyaProvider<PokemonAPITarget>(endpointClosure: stubEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        return stubbingProvider
    }
}
