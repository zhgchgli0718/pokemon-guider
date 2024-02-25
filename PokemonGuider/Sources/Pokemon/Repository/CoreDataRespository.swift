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
    func ownedPokemonChanges() -> AnyPublisher<(String, Bool), Never>
    func savePokemon(id: String, name: String?, owned: Bool?)
    func isOwnedPokemon(id: String) -> Bool
    func getAllOwnedPokemons() -> PokemonListModel
}

final class CoreDataRespository: NSObject, CoreDataRespositorySpec {

    let writeContext: NSManagedObjectContext
    let readContext: NSManagedObjectContext
    
    private lazy var fetchController = {
        let fetchRequest = NSFetchRequest<PokemonDetailCoreDataEntity>(entityName: PokemonDetailCoreDataEntity.className)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PokemonDetailCoreDataEntity.id, ascending: true)]
        
        return NSFetchedResultsController<PokemonDetailCoreDataEntity>(fetchRequest: fetchRequest, managedObjectContext: readContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    private let pokemonChanges: PassthroughSubject<(String, Bool), Never> = .init()
    
    init(writeContext: NSManagedObjectContext = CoreDataManager.defaultBackgroundContext,
         readContext: NSManagedObjectContext = CoreDataManager.viewContext) {
        self.writeContext = writeContext
        self.readContext = readContext
        
        super.init()
        fetchController.delegate = self
        try? fetchController.performFetch()
    }

    func savePokemon(id: String, name: String?, owned: Bool?) {
        let managedObject = self.findFirstOrCreate(id: id, context: writeContext)
        managedObject.id = id
        if let name = name {
            managedObject.name = name
        } else {
            managedObject.name = managedObject.name
        }
        if let owned = owned {
            managedObject.owned = owned
        } else {
            managedObject.owned = managedObject.owned
        }
        
        CoreDataManager.save(context: writeContext)
    }
    
    func isOwnedPokemon(id: String) -> Bool {
        return self.findFirst(id: id, context: readContext)?.owned ?? false
    }
    
    func ownedPokemonChanges() -> AnyPublisher<(String, Bool), Never> {
        return pokemonChanges.eraseToAnyPublisher()
    }
    
    func getAllOwnedPokemons() -> PokemonListModel {
        let fetchRequest = NSFetchRequest<PokemonDetailCoreDataEntity>(entityName: PokemonDetailCoreDataEntity.className)
        fetchRequest.predicate = NSPredicate(format: "owned == %@", "1")

        do {
            let results = try readContext.fetch(fetchRequest)
            let items = results.compactMap { entity -> PokemonListEntity.Item? in
                guard let id = entity.id else {
                   return nil
                }
                return PokemonListEntity.Item(name: entity.name ?? "", url: "https://pokeapi.co/api/v2/pokemon/\(id)/")
            }
            return PokemonListModel(entity: PokemonListEntity(count: items.count, next: nil, previous: nil, results: items))
        } catch {
            print(error)
        }
        return PokemonListModel(entity: PokemonListEntity(count: 0, next: nil, previous: nil, results: []))
    }
}

private extension CoreDataRespository {
    func findFirst(id: String, context: NSManagedObjectContext) -> PokemonDetailCoreDataEntity? {
        let fetchRequest = NSFetchRequest<PokemonDetailCoreDataEntity>(entityName: PokemonDetailCoreDataEntity.className)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let results = try context.fetch(fetchRequest)
            if let existingObject = results.first {
                return existingObject
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func findFirstOrCreate(id: String, context: NSManagedObjectContext) -> PokemonDetailCoreDataEntity {
        return self.findFirst(id: id, context: context) ?? (NSEntityDescription.insertNewObject(forEntityName: PokemonDetailCoreDataEntity.className, into: writeContext) as! PokemonDetailCoreDataEntity)
    }
}

extension CoreDataRespository: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let entity = anObject as? PokemonDetailCoreDataEntity, let id = entity.id else {
            return
        }
        pokemonChanges.send((id, entity.owned))
    }
}
