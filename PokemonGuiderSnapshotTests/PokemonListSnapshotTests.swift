//
//  PokemonListSnapshotTests.swift
//  PokemonGuiderSnapshotTests
//
//  Created by zhgchgli on 2024/2/24.
//

import XCTest
import Combine
@testable import PokemonGuider
import SnapshotTesting

final class PokemonListSnapshotTests: XCTestCase {
    
    private let record: Bool = false
    
    func testPokemonListViewControllerGridView() {
        let viewModel = FakePokemonListViewModel(cellViewObjects: makeSUT())
        viewModel.girdViewStyle = true
        viewModel.onlyDisplayOwnedPokemon = false
        let view = PokemonListViewController(viewModel: viewModel)
        assertSnapshot(matching: view, as: .image(traits: .init(userInterfaceStyle: .light)), record: record)
    }
    
    func testPokemonListViewControllerListView() {
        let viewModel = FakePokemonListViewModel(cellViewObjects: makeSUT())
        viewModel.girdViewStyle = false
        viewModel.onlyDisplayOwnedPokemon = true
        let view = PokemonListViewController(viewModel: viewModel)
        assertSnapshot(matching: view, as: .image(traits: .init(userInterfaceStyle: .light)), record: record)
    }
    
    func testPokemonCollectionViewCellDefault() {
        let viewObject = makeSUT().filter({ $0.owned == false }).first!
        
        let cellView = PokemonCollectionViewCell()
        cellView.configure(viewObject: viewObject)
        cellView.frame.size = CGSize(width: 350, height: 350)
        cellView.layoutIfNeeded()
        
        assertSnapshot(matching: cellView, as: .image(traits: .init(userInterfaceStyle: .light)), record: record)
    }
    
    func testPokemonCollectionViewCellOwned() {
        let viewObject = makeSUT().filter({ $0.owned == true }).first!
        
        let cellView = PokemonCollectionViewCell()
        cellView.configure(viewObject: viewObject)
        cellView.frame.size = CGSize(width: 350, height: 350)
        cellView.layoutIfNeeded()
        
        assertSnapshot(matching: cellView, as: .image(traits: .init(userInterfaceStyle: .light)), record: record)
    }
}

private extension PokemonListSnapshotTests {
    func makeSUT() -> [PokemonCellViewObject] {
        return [
            PokemonCellViewObject(model: PokemonDetailModel(id: "5566", name: "李奧納多皮卡丘", types: [PokemonDetailModel.PokemonType.init(name: "flying", url: ""), PokemonDetailModel.PokemonType.init(name: "ghost", url: "")], coverImage: "https://zhgchg.li/fake.png", images: [ "https://zhgchg.li/fake.png"], stats: [], owned: false)),
            PokemonCellViewObject(model: PokemonDetailModel(id: "8888", name: "柴可夫柯基", types: [PokemonDetailModel.PokemonType.init(name: "animal", url: "")], coverImage: "https://zhgchg.li/fake.png", images: [ "https://zhgchg.li/fake.png"], stats: [], owned: true)),
            PokemonCellViewObject(model: PokemonDetailModel(id: "7777", name: "零零七", types: [PokemonDetailModel.PokemonType.init(name: "flying", url: ""), PokemonDetailModel.PokemonType.init(name: "agent", url: "")], coverImage: "https://zhgchg.li/fake.png", images: [ "https://zhgchg.li/fake.png"], stats: [], owned: false)),
            PokemonCellViewObject(model: PokemonDetailModel(id: "6666", name: "周杰輪胎", types: [PokemonDetailModel.PokemonType.init(name: "flying", url: ""), PokemonDetailModel.PokemonType.init(name: "jay", url: "")], coverImage: "https://zhgchg.li/fake.png", images: [ "https://zhgchg.li/fake.png"], stats: [], owned: true)),
        ]
    }
}

private extension PokemonListSnapshotTests {
    class FakePokemonListViewModel: PokemonListViewModelSpec {
        var onlyDisplayOwnedPokemon: Bool = false
        var girdViewStyle: Bool = true
        
        func loadPokemonList() {
            //
        }
        
        func ownPokemon(id: String, owned: Bool) {
            //
        }
        
        func tapPokemon(id: String) {
            //
        }
        
        private let _cellViewObjects: [PokemonGuider.PokemonCellViewObject]
        var cellViewObjects: [PokemonGuider.PokemonCellViewObject] {
            if onlyDisplayOwnedPokemon {
                return _cellViewObjects.filter({ $0.owned == true })
            } else {
                return _cellViewObjects
            }
        }
        
        init(cellViewObjects: [PokemonGuider.PokemonCellViewObject]) {
            self._cellViewObjects = cellViewObjects
        }
        
        var didLoadPokemonList: PassthroughSubject<Void, Error> = .init()
        
        func ownedPokemonChanges() -> AnyPublisher<IndexPath, Never> {
            return Empty().eraseToAnyPublisher()
        }
    }
}
