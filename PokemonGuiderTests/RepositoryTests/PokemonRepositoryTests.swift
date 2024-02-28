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
        let pokemonRepository = PokemonRepository(provider: makeListStubProvider())
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
        let pokemonRepository = PokemonRepository(provider: makePokedexStubProvider())
        pokemonRepository.getPokemonPokedex(id: "1").sink { _ in
            //
        } receiveValue: { pokedexModel in
            XCTAssertEqual(pokedexModel.descriptions.count, 4)
            XCTAssertEqual(pokedexModel.currentLanguageDescription?.description, "Entire National dex")
            expectation.fulfill()
        }.store(in: &cancelBag)
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testGetPokemonEvolutionChain() {
        let expectation = expectation(description: "getPokemonEvolutionChain expectation")
        let pokemonRepository = PokemonRepository(provider: makeEvolutionChainStubProvider())
        pokemonRepository.getPokemonEvolutionChain(id: "1").sink { _ in
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
    func makeStubMoyaProvider(data: Data) -> MoyaProvider<PokemonAPITarget> {
        let stubEndpointClosure = { (target: PokemonAPITarget) -> Endpoint in
          return Endpoint(url: URL(target: target).absoluteString,
                          sampleResponseClosure: { .networkResponse(500 , data) },
                          method: target.method,
                          task: target.task,
                          httpHeaderFields: target.headers)
        }
        let stubbingProvider = MoyaProvider<PokemonAPITarget>(endpointClosure: stubEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        return stubbingProvider
    }
    
    func makeListStubProvider() -> MoyaProvider<PokemonAPITarget> {
        guard let pathURL = Bundle(for: type(of: self)).url(forResource: "pokemonList", withExtension: "json") else {
            fatalError("pokemonList.json not found")
        }
        return makeStubMoyaProvider(data: try! Data(contentsOf: pathURL))
    }
    
    func makeDetailStubProvider() -> MoyaProvider<PokemonAPITarget> {
        guard let pathURL = Bundle(for: type(of: self)).url(forResource: "pokemonDetail", withExtension: "json") else {
            fatalError("pokemonDetail.json not found")
        }
        return makeStubMoyaProvider(data: try! Data(contentsOf: pathURL))
    }
    
    func makePokedexStubProvider() -> MoyaProvider<PokemonAPITarget> {
        guard let pathURL = Bundle(for: type(of: self)).url(forResource: "pokemonPokedex", withExtension: "json") else {
            fatalError("pokemonPokedex.json not found")
        }
        return makeStubMoyaProvider(data: try! Data(contentsOf: pathURL))
    }
    
    func makeEvolutionChainStubProvider() -> MoyaProvider<PokemonAPITarget> {
        guard let pathURL = Bundle(for: type(of: self)).url(forResource: "pokemonEvolutionChain", withExtension: "json") else {
            fatalError("pokemonEvolutionChain.json not found")
        }
        return makeStubMoyaProvider(data: try! Data(contentsOf: pathURL))
    }
}
