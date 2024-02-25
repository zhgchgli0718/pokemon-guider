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
    
    func loadPokemonList()
}

final class PokemonListViewModel: PokemonListViewModelSpec {
    
    private(set) var didLoadPokemonList: PassthroughSubject<PokemonListModel, Error> = .init()
    private(set) var didLoadPokemonDetail: PassthroughSubject<Int, Never> = .init()
    private(set) var cellViewObjects: [PokemonCellViewObject] = []
    
    private var cancelBag = Set<AnyCancellable>()
    private var nextPage: String?
    
    let useCase: PokemonUseCaseSpec
    init(useCase: PokemonUseCaseSpec = PokemonUseCase()) {
        self.useCase = useCase
    }
    
    func loadPokemonList() {
        useCase.getPokemonList(nextPage: nextPage).handleEvents(receiveOutput: { model in
            self.cellViewObjects.append(contentsOf: model.results.map{ PokemonCellViewObject(item: $0) })
            self.nextPage = model.next
            self.didLoadPokemonList.send(model)
        }).flatMap({ model in
            return model.results.publisher.flatMap{ self.useCase.getPokemonDetail(id: $0.id) }.eraseToAnyPublisher()
        }).eraseToAnyPublisher().sink { result in
            //
        } receiveValue: { model in
            if let index = self.cellViewObjects.firstIndex(where: { $0.id == model.id}) {
                self.cellViewObjects[index] = PokemonCellViewObject(model: model)
                self.didLoadPokemonDetail.send(index)
            }
        }.store(in: &cancelBag)
    }
    
    func loadPokemonDetail(index: Int) -> AnyPublisher<(Int, PokemonCellViewObject), Error> {
        return useCase.getPokemonDetail(id: cellViewObjects[index].id).map({ (index, PokemonCellViewObject(model: $0)) }).eraseToAnyPublisher()
    }
}
