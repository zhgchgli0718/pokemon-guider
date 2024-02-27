//
//  CoreDataRespository.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/25.
//

import Foundation
import Combine
import CoreData

protocol CoreDataRespositorySpec {
    func ownedPokemonChanges() -> AnyPublisher<PokemonDetailModel, Never>
    func savePokemon(_ model: PokemonDetailModel)
    func ownPokemon(id: String, owned: Bool)
    func isOwnedPokemon(id: String) -> Bool
    
    func getPokemonDetail(id: String) -> PokemonDetailModel?
    func getAllOwnedPokemons() -> [PokemonDetailModel]
}

final class CoreDataRespository: NSObject, CoreDataRespositorySpec {

    let context: NSManagedObjectContext
    
    private lazy var saveToCoreDataVisitor: SaveToCoreDataVisitor = SaveToCoreDataVisitor(context: context)
    
    private lazy var fetchController = {
        let fetchRequest = NSFetchRequest<PokemonDetailManagedObject>(entityName: PokemonDetailManagedObject.className)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PokemonDetailManagedObject.id, ascending: true)]
        
        return NSFetchedResultsController<PokemonDetailManagedObject>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    private let pokemonChanges: PassthroughSubject<PokemonDetailModel, Never> = .init()
    
    init(context: NSManagedObjectContext = CoreDataManager.viewContext) {
        self.context = context
        
        super.init()
        fetchController.delegate = self
        try? fetchController.performFetch()
    }

    func savePokemon(_ model: PokemonDetailModel) {
        model.accept(visitor: saveToCoreDataVisitor)
    }
    
    func getPokemonDetail(id: String) -> PokemonDetailModel? {
        guard let managedObject = CoreDataManager.findFirst(PokemonDetailManagedObject.self, predicate: NSPredicate(format: "id == %@", id), context: context) else {
            return nil
        }
        return PokemonDetailModelMapping.mapping(managedObject: managedObject)
    }
    
    func isOwnedPokemon(id: String) -> Bool {
        return CoreDataManager.findFirst(PokemonDetailManagedObject.self, predicate: NSPredicate(format: "id == %@", id), context: context)?.owned ?? false
    }
    
    func ownPokemon(id: String, owned: Bool) {
        guard let model = self.getPokemonDetail(id: id) else {
            return
        }
        model.owned = owned
        model.accept(visitor: saveToCoreDataVisitor)
    }
    
    func ownedPokemonChanges() -> AnyPublisher<PokemonDetailModel, Never> {
        return pokemonChanges.eraseToAnyPublisher()
    }
    
    func getAllOwnedPokemons() -> [PokemonDetailModel] {
        return CoreDataManager.findAll(PokemonDetailManagedObject.self, predicate: NSPredicate(format: "owned == %@", "1"), context: context).map { PokemonDetailModelMapping.mapping(managedObject: $0) }
    }
}

extension CoreDataRespository: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let managedObject = anObject as? PokemonDetailManagedObject else {
            return
        }
        pokemonChanges.send(PokemonDetailModelMapping.mapping(managedObject: managedObject))
    }
}
