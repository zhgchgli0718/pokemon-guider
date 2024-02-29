//
//  PokemonUseCaseTests.swift
//  PokemonGuiderTests
//
//  Created by zhgchgli on 2024/2/28.
//

import XCTest
@testable import PokemonGuider
import Combine

final class PokemonUseCaseTests: XCTestCase {
    
    private var cancelBag = Set<AnyCancellable>()
    
    func testGetPokemonList() {
        let sut = makeSUT()
        
        let testExpectation = expectation(description: "getPokemonList expectation")
        
        let fakePokemonRepository = FakePokemonRepository(listModel: sut.0, detailModels: sut.1)
        let fakeCoreDataPokemonRepository = FakeCoreDataRespository(detailModels: [])
        let useCase = PokemonUseCase(repository: fakePokemonRepository, coreDataRepository: fakeCoreDataPokemonRepository)
        useCase.getPokemonList(nextPage: nil).sink { _ in
            //
        } receiveValue: { (listModel, detailModels) in
            XCTAssertEqual(listModel.count, sut.0.count)
            XCTAssertEqual(detailModels.count, sut.1.count)
            testExpectation.fulfill()
        }.store(in: &cancelBag)

        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testGetPokemonDetailByID() {
        let sut = makeSUT()
        
        let testExpectation = expectation(description: "getPokemonDetail expectation")
        
        let fakePokemonRepository = FakePokemonRepository(listModel: sut.0, detailModels: sut.1)
        let fakeCoreDataPokemonRepository = FakeCoreDataRespository(detailModels: [])
        let useCase = PokemonUseCase(repository: fakePokemonRepository, coreDataRepository: fakeCoreDataPokemonRepository)
        useCase.getPokemonDetail(id: sut.1.first!.id).sink { _ in
            //
        } receiveValue: { detailModel in
            XCTAssertEqual(detailModel.id, sut.1.first!.id)
            XCTAssertEqual(detailModel.name, sut.1.first!.name)
            
            // also need to save to core data repository
            XCTAssertEqual(fakeCoreDataPokemonRepository.detailModels.count, 1)
            XCTAssertEqual(fakeCoreDataPokemonRepository.getPokemonDetail(id: detailModel.id)!.id, detailModel.id)
            testExpectation.fulfill()
        }.store(in: &cancelBag)
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testGetPokemonDetailByName() {
        let sut = makeSUT()
        
        let testExpectation = expectation(description: "getPokemonDetail expectation")
        
        let fakePokemonRepository = FakePokemonRepository(listModel: sut.0, detailModels: sut.1)
        let fakeCoreDataPokemonRepository = FakeCoreDataRespository(detailModels: [])
        let useCase = PokemonUseCase(repository: fakePokemonRepository, coreDataRepository: fakeCoreDataPokemonRepository)
        useCase.getPokemonDetail(name: sut.1.first!.name).sink { _ in
            //
        } receiveValue: { detailModel in
            XCTAssertEqual(detailModel.id, sut.1.first!.id)
            XCTAssertEqual(detailModel.name, sut.1.first!.name)
            
            // also need to save to core data repository
            XCTAssertEqual(fakeCoreDataPokemonRepository.detailModels.count, 1)
            XCTAssertEqual(fakeCoreDataPokemonRepository.getPokemonDetail(id: detailModel.id)!.id, detailModel.id)
            testExpectation.fulfill()
        }.store(in: &cancelBag)
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testGetPokemonPokedex() {
        let sut = makeSUT()
        
        let testExpectation = expectation(description: "getPokemonPokedex expectation")
        
        let fakePokemonRepository = FakePokemonRepository(listModel: sut.0, detailModels: sut.1)
        let fakeCoreDataPokemonRepository = FakeCoreDataRespository(detailModels: [])
        let useCase = PokemonUseCase(repository: fakePokemonRepository, coreDataRepository: fakeCoreDataPokemonRepository)
        useCase.getPokemonPokedex(id: "1").sink { _ in
            //
        } receiveValue: { pokedexModel in
            XCTAssertEqual(pokedexModel.currentLanguageDescription?.description, "test")
            testExpectation.fulfill()
        }.store(in: &cancelBag)
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testGetPokemonEvolutionChain() {
        let sut = makeSUT()
        
        let testExpectation = expectation(description: "getPokemonEvolutionChain expectation")
        
        let fakePokemonRepository = FakePokemonRepository(listModel: sut.0, detailModels: sut.1)
        let fakeCoreDataPokemonRepository = FakeCoreDataRespository(detailModels: [])
        let useCase = PokemonUseCase(repository: fakePokemonRepository, coreDataRepository: fakeCoreDataPokemonRepository)
        useCase.getPokemonEvolutionChain(id: "id").sink { _ in
            //
        } receiveValue: { pokemonDetailModels in
            XCTAssertEqual(pokemonDetailModels.count, 2)
            XCTAssertEqual(pokemonDetailModels[0].id, "8888")
            XCTAssertEqual(pokemonDetailModels[1].id, "5566")
            testExpectation.fulfill()
        }.store(in: &cancelBag)
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testGetAllOwnedPokemon() {
        let sut = makeSUT()
        
        let testExpectation = expectation(description: "getAllOwnedPokemon expectation")
        
        let fakePokemonRepository = FakePokemonRepository(listModel: sut.0, detailModels: [])
        let fakeCoreDataPokemonRepository = FakeCoreDataRespository(detailModels: sut.1)
        let useCase = PokemonUseCase(repository: fakePokemonRepository, coreDataRepository: fakeCoreDataPokemonRepository)
        useCase.getAllOwnedPokemon().sink { _ in
            //
        } receiveValue: { pokemonDetailModels in
            XCTAssertFalse(pokemonDetailModels.contains(where: { !($0.owned ?? false) }))
            XCTAssertEqual(pokemonDetailModels.count, sut.1.filter{ $0.owned ?? false }.count)
            testExpectation.fulfill()
        }.store(in: &cancelBag)
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testIsOwnedPokemon() {
        let sut = makeSUT()
        let fakePokemonRepository = FakePokemonRepository(listModel: sut.0, detailModels: [])
        let fakeCoreDataPokemonRepository = FakeCoreDataRespository(detailModels: sut.1)
        let useCase = PokemonUseCase(repository: fakePokemonRepository, coreDataRepository: fakeCoreDataPokemonRepository)
        
        XCTAssertTrue(useCase.isOwnedPokemon(id: sut.1.first(where: { $0.owned ?? false })!.id))
        XCTAssertFalse(useCase.isOwnedPokemon(id: sut.1.first(where: { !($0.owned ?? false) })!.id))
    }
}

private extension PokemonUseCaseTests {
    class FakePokemonRepository: PokemonRepositorySpec {

        var detailModels: [PokemonDetailModel]
        var listModel: PokemonListModel
        
        init(listModel: PokemonListModel, detailModels: [PokemonDetailModel]) {
            self.detailModels = detailModels
            self.listModel = listModel
        }
        
        func getPokemonList(nextPage: String?) -> AnyPublisher<PokemonGuider.PokemonListModel, Error> {
            return Just(listModel).setFailureType(to: Error.self).eraseToAnyPublisher()
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
            return Just(PokemonGuider.PokemonPokedexModel(descriptions: [.init(description: "test", language: .init(name: "en", url: "fake://"))])).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func getPokemonSpecies(id: String) -> AnyPublisher<PokemonGuider.PokemonSpeciesModel, Error> {
            return Just(PokemonGuider.PokemonSpeciesModel(evolutionChainURL: "fake://evolution-chain/1/")).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func getPokemonEvolutionChain(resourceID: String) -> AnyPublisher<PokemonGuider.PokemonEvolutionChainModel, Error> {
            return Just(PokemonGuider.PokemonEvolutionChainModel(chainSpecies: [PokemonEvolutionChainModel.ChainSpecies(name: "李奧納多皮卡丘", url: "fake://evolution-chain/5566/", order: 1), PokemonEvolutionChainModel.ChainSpecies(name: "柴可夫柯基", url: "fake://evolution-chain/8888/", order: 0)])).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    class FakeCoreDataRespository: CoreDataRespositorySpec {
        
        var detailModels: [PokemonDetailModel]
        init(detailModels: [PokemonDetailModel]) {
            self.detailModels = detailModels
        }
        
        func ownedPokemonChanges() -> AnyPublisher<PokemonGuider.PokemonDetailModel, Never> {
            return Empty().eraseToAnyPublisher()
        }
        
        func savePokemon(_ model: PokemonGuider.PokemonDetailModel) {
            detailModels.append(model)
        }
        
        func ownPokemon(id: String, owned: Bool) {
            getPokemonDetail(id: id)?.owned = owned
        }
        
        func isOwnedPokemon(id: String) -> Bool {
            return getPokemonDetail(id: id)?.owned == true
        }
        
        func getPokemonDetail(id: String) -> PokemonGuider.PokemonDetailModel? {
            guard let detailModel = detailModels.first(where: { $0.id == id }) else {
                return nil
            }
            return detailModel
        }
        
        func getAllOwnedPokemon() -> [PokemonGuider.PokemonDetailModel] {
            return detailModels.filter { $0.owned == true }
        }
    }
}

private extension PokemonUseCaseTests {
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
