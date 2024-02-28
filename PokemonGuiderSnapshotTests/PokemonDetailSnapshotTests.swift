//
//  PokemonDetailSnapshotTests.swift
//  PokemonGuiderSnapshotTests
//
//  Created by zhgchgli on 2024/2/28.
//

import XCTest
import Combine
@testable import PokemonGuider
import SnapshotTesting

final class PokemonDetailSnapshotTests: XCTestCase {
    
    private let record: Bool = false
    
    func testPokemonDetailViewController() {
        let sut = makeSUT()
        let viewModel = FakePokemonDetailViewModel(detailModel: sut.0, pokedex: sut.1, evolutionChain: sut.2)
        let view = PokemonDetailViewController(viewModel: viewModel)
        assertSnapshot(matching: view, as: .image(traits: .init(userInterfaceStyle: .light)), record: record)
    }
    
    func testPokemonDetailViewControllerOwned() {
        let sut = makeSUT()
        sut.0.owned = true
        let viewModel = FakePokemonDetailViewModel(detailModel: sut.0, pokedex: sut.1, evolutionChain: sut.2)
        let view = PokemonDetailViewController(viewModel: viewModel)
        assertSnapshot(matching: view, as: .image(traits: .init(userInterfaceStyle: .light)), record: record)
    }
}

private extension PokemonDetailSnapshotTests {
    func makeSUT() -> (PokemonDetailModel, PokemonPokedexModel, [PokemonDetailModel]) {
        let language = Locale.current.language.languageCode?.identifier ?? "en"
        return (
            PokemonDetailModel(id: "5566", name: "李奧納多皮卡丘", types: [PokemonDetailModel.PokemonType.init(name: "flying", url: ""), PokemonDetailModel.PokemonType.init(name: "ghost", url: "")], coverImage: "https://zhgchg.li/fake.png", images: [ "https://zhgchg.li/fake.png"], stats: [.init(name: "爆破", url: "", baseStat: 10, effort: 10), .init(name: "衝撞", url: "", baseStat: 70, effort: 0)], owned: false),
            PokemonPokedexModel(descriptions: [PokemonPokedexModel.Description(description: "你好", language: PokemonPokedexModel.Description.Language(name: language, url: ""))]),
            [
                PokemonDetailModel(id: "8888", name: "柴可夫柯基", types: [PokemonDetailModel.PokemonType.init(name: "animal", url: "")], coverImage: "https://zhgchg.li/fake.png", images: [ "https://zhgchg.li/fake.png"], stats: [], owned: true),
                PokemonDetailModel(id: "7777", name: "零零七", types: [PokemonDetailModel.PokemonType.init(name: "flying", url: ""), PokemonDetailModel.PokemonType.init(name: "agent", url: "")], coverImage: "https://zhgchg.li/fake.png", images: [ "https://zhgchg.li/fake.png"], stats: [], owned: false)
            ]
        )
    }
}

private extension PokemonDetailSnapshotTests {
    class FakePokemonDetailViewModel: PokemonDetailViewModelSpec {
        var id: String {
            return detailModel.id
        }
        
        var detailModel: PokemonDetailModel
        var pokedex: PokemonPokedexModel
        var evolutionChain: [PokemonDetailModel]
        
        init(detailModel: PokemonDetailModel, pokedex: PokemonPokedexModel, evolutionChain: [PokemonDetailModel]) {
            self.detailModel = detailModel
            self.pokedex = pokedex
            self.evolutionChain = evolutionChain
        }
        
        func loadPokemonDetail() -> AnyPublisher<PokemonGuider.PokemonDetailModel, Error> {
            return Just(detailModel).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func loadPokemonPokedex() -> AnyPublisher<PokemonGuider.PokemonPokedexModel, Error> {
            return Just(pokedex).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func loadPokemonEvolutionChain() -> AnyPublisher<[PokemonGuider.PokemonDetailModel], Error> {
            return Just(evolutionChain).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func tapPokemon(id: String) {
            //
        }
        
        func isOwnedPokemon() -> Bool {
            //
            return detailModel.owned ?? false
        }
        
        func ownPokemon(owned: Bool) {
            //
        }
        
        func ownedPokemonChanges() -> AnyPublisher<PokemonGuider.PokemonDetailModel, Never> {
            return Empty().eraseToAnyPublisher()
        }
    }
}
