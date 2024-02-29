//
//  PokemonDetailViewModelTests.swift
//  PokemonGuiderTests
//
//  Created by zhgchgli on 2024/2/28.
//

import XCTest
@testable import PokemonGuider
import Combine

final class PokemonDetailViewModelTests: XCTestCase {
    
    private var cancelBag = Set<AnyCancellable>()
    private var pokemonDidTapID: String? = nil
    
    func testLoadPokemonDetail() {
        let sut = makeSUT()
        let viewModel = PokemonDetailViewModel(id: sut.id, useCase: FakePokemonUseCase(detailModel: sut))
        
        let testExpectation = expectation(description: "loadPokemonDetail expectation")
        
        viewModel.loadPokemonDetail().sink { _ in
            //
        } receiveValue: { detailModel in
            XCTAssertEqual(detailModel.id, sut.id)
            XCTAssertEqual(detailModel.name, sut.name)
            testExpectation.fulfill()
        }.store(in: &cancelBag)

        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testGetPokemonPokedex() {
        let sut = makeSUT()
        let viewModel = PokemonDetailViewModel(id: sut.id, useCase: FakePokemonUseCase(detailModel: sut))
        
        let testExpectation = expectation(description: "loadPokemonPokedex expectation")
        
        viewModel.loadPokemonPokedex().sink { _ in
            //
        } receiveValue: { pokedex in
            XCTAssertEqual(pokedex.currentLanguageDescription?.description, "test")
            testExpectation.fulfill()
        }.store(in: &cancelBag)

        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testLoadPokemonEvolutionChain() {
        let sut = makeSUT()
        let viewModel = PokemonDetailViewModel(id: sut.id, useCase: FakePokemonUseCase(detailModel: sut))
        
        let testExpectation = expectation(description: "loadPokemonEvolutionChain expectation")
        
        viewModel.loadPokemonEvolutionChain().sink { _ in
            //
        } receiveValue: { chain in
            XCTAssertEqual(chain.chainSpecies.first?.name, "李奧納多皮卡丘")
            testExpectation.fulfill()
        }.store(in: &cancelBag)

        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testOwnPokemon() {
        let sut = makeSUT()
        let viewModel = PokemonDetailViewModel(id: sut.id, useCase: FakePokemonUseCase(detailModel: sut))
        viewModel.ownPokemon(owned: true)
        XCTAssertEqual(sut.owned, true)
    }
    
    func testTapPokemon() {
        let sut = makeSUT()
        let viewModel = PokemonDetailViewModel(id: sut.id, useCase: FakePokemonUseCase(detailModel: sut))
        viewModel.delegate = self
        viewModel.tapPokemon(id: "123")
        XCTAssertEqual(pokemonDidTapID, "123")
    }
}

extension PokemonDetailViewModelTests: PokemonDetailViewModelDelegate {
    func pokemonDetailViewModel(_ viewModel: PokemonGuider.PokemonDetailViewModelSpec, pokemonDidTap id: String) {
        pokemonDidTapID = id
    }
}

private extension PokemonDetailViewModelTests {
    class FakePokemonUseCase: PokemonUseCaseSpec {
        
        let detailModel: PokemonDetailModel
        
        init(detailModel: PokemonDetailModel) {
            self.detailModel = detailModel
        }
        
        func getPokemonList(nextPage: String?) -> AnyPublisher<(PokemonGuider.PokemonListModel, [PokemonGuider.PokemonDetailModel]), Error> {
            return Empty().eraseToAnyPublisher()
        }
        
        func getPokemonDetail(id: String) -> AnyPublisher<PokemonGuider.PokemonDetailModel, Error> {
            return Just(detailModel).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func getPokemonPokedex(id: String) -> AnyPublisher<PokemonGuider.PokemonPokedexModel, Error> {
            return Just(PokemonGuider.PokemonPokedexModel(descriptions: [.init(description: "test", language: .init(name: "en", url: "fake://"))])).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        
        func getPokemonEvolutionChain(id: String) -> AnyPublisher<PokemonGuider.PokemonEvolutionChainModel, Error> {
            return Just(PokemonGuider.PokemonEvolutionChainModel(chainSpecies: [.init(name: detailModel.name, url: "fake://pokemon/\(detailModel.id)/", order: 0)])).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func isOwnedPokemon(id: String) -> Bool {
            return detailModel.owned == true
        }
        
        func ownPokemon(id: String, owned: Bool) {
            detailModel.owned = owned
        }
        
        func ownedPokemonChanges() -> AnyPublisher<PokemonGuider.PokemonDetailModel, Never> {
            return Empty().eraseToAnyPublisher()
        }
        
        func getAllOwnedPokemon() -> AnyPublisher<[PokemonGuider.PokemonDetailModel], Error> {
            return Empty().eraseToAnyPublisher()
        }
    }
}

private extension PokemonDetailViewModelTests {
    func makeSUT() -> PokemonDetailModel {
        return PokemonDetailModel(id: "5566", name: "李奧納多皮卡丘", types: [PokemonDetailModel.PokemonType.init(name: "flying", url: ""), PokemonDetailModel.PokemonType.init(name: "ghost", url: "")], coverImage: "https://zhgchg.li/fake.png", images: [ "https://zhgchg.li/fake.png"], stats: [], owned: false)
    }
}
