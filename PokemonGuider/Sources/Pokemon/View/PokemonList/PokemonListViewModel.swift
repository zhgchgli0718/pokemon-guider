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
    var cellViewObjects: [PokemonCellViewObject] { get }
   
    var didLoadPokemonList: PassthroughSubject<PokemonListModel, Error> { get }
    var didLoadPokemonDetail: PassthroughSubject<Int, Never> { get }
    
    var loadOwnedPokemon: Bool { get set }
    var girdViewStyle: Bool { get set }
    
    func loadPokemonList()
    func ownPokemon(id: String, owned: Bool)
    func ownedPokemonChanges() -> AnyPublisher<(Int, Bool), Never>
}

final class PokemonListViewModel: PokemonListViewModelSpec {
    
    private(set) var didLoadPokemonList: PassthroughSubject<PokemonListModel, Error> = .init()
    private(set) var didLoadPokemonDetail: PassthroughSubject<Int, Never> = .init()
    private(set) var cellViewObjects: [PokemonCellViewObject] = []
    var loadOwnedPokemon: Bool = false {
        didSet {
            cellViewObjects = []
            nextPage = nil
            firstLoad = true
            loadPokemonList()
        }
    }
    var girdViewStyle: Bool = true
    
    private var cancelBag = Set<AnyCancellable>()
    private var nextPage: String?
    private var firstLoad: Bool = true
    
    let useCase: PokemonUseCaseSpec
    init(useCase: PokemonUseCaseSpec = PokemonUseCase()) {
        self.useCase = useCase
    }
    
    func loadPokemonList() {
        if !firstLoad && nextPage == nil {
            return
        }
        
        if loadOwnedPokemon {
            handleList(publisher: useCase.getAllOwnedPokemons())
        } else {
            handleList(publisher:useCase.getPokemonList(nextPage: nextPage))
        }
    }
    
    func loadPokemonDetail(index: Int) -> AnyPublisher<(Int, PokemonCellViewObject), Error> {
        return useCase.getPokemonDetail(id: cellViewObjects[index].id).map({ (index, PokemonCellViewObject(model: $0)) }).eraseToAnyPublisher()
    }
    
    func ownPokemon(id: String, owned: Bool) {
        useCase.ownPokemon(id: id, owned: owned)
    }
    
    func ownedPokemonChanges() -> AnyPublisher<(Int, Bool), Never> {
        return useCase.ownedPokemonChanges().compactMap({ (id, owned) in
            guard let index = self.cellViewObjects.firstIndex(where: { $0.id == id}) else {
                return nil
            }
            self.cellViewObjects[index].owned = owned
            return (index, owned)
        }).eraseToAnyPublisher()
    }
}

private extension PokemonListViewModel {
    func handleList(publisher: AnyPublisher<PokemonListModel, Error>) {
        publisher.handleEvents(receiveOutput: { model in
            self.cellViewObjects.append(contentsOf: model.results.map{ PokemonCellViewObject(item: $0) })
            self.nextPage = model.next
            self.didLoadPokemonList.send(model)
        }).flatMap({ model in
            return model.results.publisher.flatMap{ self.useCase.getPokemonDetail(id: $0.id) }.eraseToAnyPublisher()
        }).eraseToAnyPublisher().sink { result in
            self.firstLoad = false
        } receiveValue: { model in
            if let index = self.cellViewObjects.firstIndex(where: { $0.id == model.id}) {
                var viewObject = PokemonCellViewObject(model: model)
                viewObject.owned = self.useCase.isOwnedPokemon(id: model.id)
                self.cellViewObjects[index] = viewObject
                self.didLoadPokemonDetail.send(index)
            }
        }.store(in: &cancelBag)
    }
}
