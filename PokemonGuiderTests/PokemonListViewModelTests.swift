//
//  PokemonListViewModelTests.swift
//  PokemonGuiderTests
//
//  Created by zhgchgli on 2024/2/28.
//

import XCTest
@testable import PokemonGuider
import Combine

final class PokemonListViewModelTests: XCTestCase {
    
    private var cancelBag = Set<AnyCancellable>()
    private var pokemonDidTapID: String? = nil
    
    func testLoadPokemonList() {
        let sut = makeSUT()
        let viewModel = PokemonListViewModel(useCase: FakePokemonUseCase(listModel: sut.0, detailModels: sut.1))
        
        let testExpectation = expectation(description: "getPokemonList expectation")
        
        viewModel.didLoadPokemonList.sink { _ in
            //
        } receiveValue: { _ in
            let viewObjects = viewModel.cellViewObjects
            XCTAssertEqual(viewObjects.count, 4)
            XCTAssertEqual(viewObjects.first(where: { $0.id == sut.1.first!.id })!.id, sut.1.first!.id)
            XCTAssertEqual(viewObjects.first(where: { $0.id == sut.1.first!.id })!.name, sut.1.first!.name)
            testExpectation.fulfill()
        }.store(in: &cancelBag)
        viewModel.loadPokemonList()

        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testOnlyDisplayOwnedPokemon() {
        let sut = makeSUT()
        let viewModel = PokemonListViewModel(useCase: FakePokemonUseCase(listModel: sut.0, detailModels: sut.1))
        
        let testExpectation = expectation(description: "getPokemonList expectation")
        
        viewModel.didLoadPokemonList.sink { _ in
            //
        } receiveValue: { _ in
            let viewObjects = viewModel.cellViewObjects
            XCTAssertEqual(viewObjects.count, 2)
            XCTAssertEqual(viewObjects.first(where: { $0.owned == true })!.id, sut.1.first(where: { $0.owned == true })!.id)
            XCTAssertEqual(viewObjects.first(where: { $0.owned == true })!.name, sut.1.first(where: { $0.owned == true })!.name)
            testExpectation.fulfill()
        }.store(in: &cancelBag)
        viewModel.onlyDisplayOwnedPokemon = true

        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testOwnPokemon() {
        let sut = makeSUT()
        let viewModel = PokemonListViewModel(useCase: FakePokemonUseCase(listModel: sut.0, detailModels: sut.1))
        viewModel.ownPokemon(id: sut.1.first!.id, owned: true)
        XCTAssertEqual(sut.1.first?.owned, true)
    }
    
    func testTapPokemon() {
        let sut = makeSUT()
        let viewModel = PokemonListViewModel(useCase: FakePokemonUseCase(listModel: sut.0, detailModels: sut.1))
        viewModel.delegate = self
        viewModel.tapPokemon(id: "123")
        XCTAssertEqual(pokemonDidTapID, "123")
    }
}

extension PokemonListViewModelTests: PokemonListViewModelDelegate {
    func pokemonListViewModel(_ viewModel: PokemonGuider.PokemonListViewModelSpec, pokemonDidTap id: String) {
        pokemonDidTapID = id
    }
}

private extension PokemonListViewModelTests {
    class FakePokemonUseCase: PokemonUseCaseSpec {
        
        var detailModels: [PokemonDetailModel]
        var listModel: PokemonListModel
        
        init(listModel: PokemonListModel, detailModels: [PokemonDetailModel]) {
            self.detailModels = detailModels
            self.listModel = listModel
        }
        
        func getPokemonList(nextPage: String?) -> AnyPublisher<(PokemonGuider.PokemonListModel, [PokemonGuider.PokemonDetailModel]), Error> {
            return Just((listModel, detailModels)).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func getPokemonDetail(id: String) -> AnyPublisher<PokemonGuider.PokemonDetailModel, Error> {
            guard let detailModel = detailModels.first(where: { $0.id == id }) else {
                return Empty().eraseToAnyPublisher()
            }
            return Just(detailModel).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func getPokemonDetail(name: String) -> AnyPublisher<PokemonGuider.PokemonDetailModel, Error> {
            guard let detailModel = detailModels.first(where: { $0.name == name }) else {
                return Empty().eraseToAnyPublisher()
            }
            return Just(detailModel).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func getPokemonPokedex(id: String) -> AnyPublisher<PokemonGuider.PokemonPokedexModel, Error> {
            return Just(PokemonGuider.PokemonPokedexModel(descriptions: [.init(description: "test", language: .init(name: "Hi", url: "fake://"))])).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func getPokemonEvolutionChain(id: String) -> AnyPublisher<[PokemonGuider.PokemonDetailModel], Error> {
            return Just(detailModels).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func isOwnedPokemon(id: String) -> Bool {
            guard let detailModel = detailModels.first(where: { $0.id == id }) else {
                return false
            }
            
            return detailModel.owned == true
        }
        
        func ownPokemon(id: String, owned: Bool) {
            guard let detailModel = detailModels.first(where: { $0.id == id }) else {
                return
            }
            
            detailModel.owned = owned
        }
        
        func ownedPokemonChanges() -> AnyPublisher<PokemonGuider.PokemonDetailModel, Never> {
            return Empty().eraseToAnyPublisher()
        }
        
        func getAllOwnedPokemon() -> AnyPublisher<[PokemonGuider.PokemonDetailModel], Error> {
            return Just(detailModels.filter { $0.owned == true }).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
}

private extension PokemonListViewModelTests {
    func makeSUT() -> (PokemonListModel, [PokemonDetailModel]) {
        let models = [
            PokemonDetailModel(id: "5566", name: "李奧納多皮卡丘", types: [PokemonDetailModel.PokemonType.init(name: "flying", url: ""), PokemonDetailModel.PokemonType.init(name: "ghost", url: "")], coverImage: "https://zhgchg.li/fake.png", images: [ "https://zhgchg.li/fake.png"], stats: [], owned: false),
            PokemonDetailModel(id: "8888", name: "柴可夫柯基", types: [PokemonDetailModel.PokemonType.init(name: "animal", url: "")], coverImage: "https://zhgchg.li/fake.png", images: [ "https://zhgchg.li/fake.png"], stats: [], owned: true),
            PokemonDetailModel(id: "7777", name: "零零七", types: [PokemonDetailModel.PokemonType.init(name: "flying", url: ""), PokemonDetailModel.PokemonType.init(name: "agent", url: "")], coverImage: "https://zhgchg.li/fake.png", images: [ "https://zhgchg.li/fake.png"], stats: [], owned: false),
            PokemonDetailModel(id: "6666", name: "周杰輪胎", types: [PokemonDetailModel.PokemonType.init(name: "flying", url: ""), PokemonDetailModel.PokemonType.init(name: "jay", url: "")], coverImage: "https://zhgchg.li/fake.png", images: [ "https://zhgchg.li/fake.png"], stats: [], owned: true),
        ]
        return (
            PokemonListModel(count: models.count, next: nil, previous: nil, results: models.map { .init(name: $0.name, url: "https://pokeapi.co/api/v2/pokemon/\($0.id)") })
            ,
            models
        )
    }
}
