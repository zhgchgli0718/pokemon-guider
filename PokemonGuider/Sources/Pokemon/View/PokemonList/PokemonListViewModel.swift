//
//  PokemonViewModel.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import Combine
import Moya

protocol PokemonListViewModelSpec {
    // Input
    /// Filter to display only owned Pokemon.
    var loadOwnedPokemon: Bool { get set }
    /// Request to load Pokemon List
    func loadPokemonList()
    /// Mark Pokemon as owned
    func ownPokemon(id: String, owned: Bool)
    
    // Output
    /// CellViewObjects Data List
    var cellViewObjects: [PokemonCellViewObject] { get }
    /// loadPokemonList() Did Loaded Listener
    var didLoadPokemonList: PassthroughSubject<Void, Error> { get }
    /// Mark/unmark Pokemon as owned  Listener
    func ownedPokemonChanges() -> AnyPublisher<IndexPath, Never>
}

final class PokemonListViewModel: PokemonListViewModelSpec {
    
    var loadOwnedPokemon: Bool = false {
        didSet {
            cellViewObjects = []
            nextPage = nil
            firstLoad = true
            loadPokemonList()
        }
    }
    
    private(set) var didLoadPokemonList: PassthroughSubject<Void, Error> = .init()
    private(set) var cellViewObjects: [PokemonCellViewObject] = []
    private var cancelBag = Set<AnyCancellable>()
    private var nextPage: String?
    private var firstLoad: Bool = true
    
    let useCase: PokemonUseCaseSpec
    init(useCase: PokemonUseCaseSpec = PokemonUseCase()) {
        self.useCase = useCase
    }
    
    func loadPokemonList() {
        // If firstLoad is false and nextPage equals nil, it means we have reached the end.
        if !firstLoad && nextPage == nil {
            return
        }
        firstLoad = false
        //
        
        if loadOwnedPokemon {
            useCase.getAllOwnedPokemons().sink { _ in
                //
            } receiveValue: { detailModels in
                let viewObjects = detailModels.map { PokemonCellViewObject(model: $0) }
                self.cellViewObjects = viewObjects
                self.didLoadPokemonList.send()
                self.nextPage = nil
            }.store(in: &cancelBag)
        } else {
            useCase.getPokemonList(nextPage: nextPage).sink { _ in
                //
            } receiveValue: { (listModel, detailModels) in
                let viewObjects = detailModels.map { PokemonCellViewObject(model: $0) }
                self.cellViewObjects.append(contentsOf: viewObjects)
                self.didLoadPokemonList.send()
                self.nextPage = listModel.next
            }.store(in: &cancelBag)
        }

    }
    
    func ownPokemon(id: String, owned: Bool) {
        useCase.ownPokemon(id: id, owned: owned)
    }
    
    func ownedPokemonChanges() -> AnyPublisher<IndexPath, Never> {
        return useCase.ownedPokemonChanges().compactMap { detailModel -> IndexPath? in
            guard let row = self.cellViewObjects.firstIndex(where: { $0.id == detailModel.id }) else {
                return nil
            }
            self.cellViewObjects[row] = PokemonCellViewObject(model: detailModel)
            return IndexPath(row: row, section: 0)
        }.eraseToAnyPublisher()
    }
}
