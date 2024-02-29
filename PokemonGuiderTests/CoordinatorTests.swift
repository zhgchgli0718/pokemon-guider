//
//  CoordinatorTests.swift
//  PokemonGuiderTests
//
//  Created by zhgchgli on 2024/2/24.
//

import XCTest
@testable import PokemonGuider
import Combine

final class CoordinatorTests: XCTestCase {
    
    func testCoordinatorAdd() {
        let aCoordinator = FakeCoordinatorA()
        let bCoordinator = FakeCoordinatorB()
        
        aCoordinator.add(child: bCoordinator)
        XCTAssertEqual(aCoordinator.childCoordinators.count, 1)
        XCTAssertTrue(aCoordinator.childCoordinators.first === bCoordinator)
        
        // add sam coordinator again, should remain
        aCoordinator.add(child: bCoordinator)
        XCTAssertEqual(aCoordinator.childCoordinators.count, 1)
        XCTAssertTrue(aCoordinator.childCoordinators.first === bCoordinator)
    }
    
    func testCoordinatorRemove() {
        let aCoordinator = FakeCoordinatorA()
        let bCoordinator = FakeCoordinatorB()
        
        aCoordinator.add(child: bCoordinator)
        XCTAssertEqual(aCoordinator.childCoordinators.count, 1)
        XCTAssertTrue(aCoordinator.childCoordinators.first === bCoordinator)
        
        aCoordinator.remove(child: bCoordinator)
        XCTAssertEqual(aCoordinator.childCoordinators.count, 0)
    }
    
    func testPokemonCoordinator() {
        let navigationController = SpyUINavigationController()
        let pokemonCoordinator = PokemonCoordinator(navigationController: navigationController)
        
        // Test Default List
        pokemonCoordinator.start()
        XCTAssertTrue(navigationController.topViewController! is PokemonListViewController)
        //
        
        // Test List GoTo Detail
        navigationController.pushViewController = nil
        pokemonCoordinator.pokemonListViewModel(FakePokemonListViewModel(), pokemonDidTap: "1")
        XCTAssertTrue(navigationController.pushViewController! is PokemonDetailViewController)
        
        // Test Detail GoTo Detail
        navigationController.pushViewController = nil
        pokemonCoordinator.pokemonDetailViewModel(FakePokemonDetailViewModel(), pokemonDidTap: "1")
        XCTAssertTrue(navigationController.pushViewController! is PokemonDetailViewController)
    }
}

private extension CoordinatorTests {
    class FakeCoordinatorA: Coordinator {
        var childCoordinators: [PokemonGuider.Coordinator] = []
    }
    class FakeCoordinatorB: Coordinator {
        var childCoordinators: [PokemonGuider.Coordinator] = []
    }
    
    class SpyUINavigationController: UINavigationController {
        
        var pushViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}

private extension CoordinatorTests {
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
        
        var cellViewObjects: [PokemonGuider.PokemonCellViewObject] = []
        
        var didLoadPokemonList: PassthroughSubject<Void, Error> = .init()
        
        func ownedPokemonChanges() -> AnyPublisher<IndexPath, Never> {
            return Empty().eraseToAnyPublisher()
        }
    }
    
    class FakePokemonDetailViewModel: PokemonDetailViewModelSpec {
        var id: String = ""
        
        func loadPokemonDetail() -> AnyPublisher<PokemonGuider.PokemonDetailModel, Error> {
            return Empty().eraseToAnyPublisher()
        }
        
        func loadPokemonPokedex() -> AnyPublisher<PokemonGuider.PokemonPokedexModel, Error> {
            return Empty().eraseToAnyPublisher()
        }
        
        func loadPokemonEvolutionChain() -> AnyPublisher<PokemonGuider.PokemonEvolutionChainModel, Error> {
            return Empty().eraseToAnyPublisher()
        }
        
        func tapPokemon(id: String) {
            
        }
        
        func isOwnedPokemon() -> Bool {
            return false
        }
        
        func ownPokemon(owned: Bool) {
            
        }
        
        func ownedPokemonChanges() -> AnyPublisher<PokemonGuider.PokemonDetailModel, Never> {
            return Empty().eraseToAnyPublisher()
        }
    }
}
