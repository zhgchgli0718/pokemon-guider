//
//  CoreDataManager.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/25.
//

import Foundation
import CoreData
import Combine

public class CoreDataManager: NSObject {
    static var shared: CoreDataManager = CoreDataManager()
    
    static let modelName = "PokemonGuider"
    
    private override init() {
        
    }
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataManager.modelName)
        
//        if AppConstants.IsRunningTest {
//            let description = NSPersistentStoreDescription()
//            description.type = NSInMemoryStoreType
//            container.persistentStoreDescriptions = [description]
//        }
        
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                print(error)
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    static var viewContext: NSManagedObjectContext {
        return CoreDataManager.shared.container.viewContext
    }
    
    static func save(context: NSManagedObjectContext) {
        context.perform {
            if !context.hasChanges { return }
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    static func findFirst<T: NSManagedObject>(_ managedObject: T.Type, predicate: NSPredicate, context: NSManagedObjectContext) -> T? {
        let fetchRequest = NSFetchRequest<T>(entityName: T.className)
        fetchRequest.predicate = predicate

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
    
    static func findAll<T: NSManagedObject>(_ managedObject: T.Type, predicate: NSPredicate, context: NSManagedObjectContext) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: T.className)
        fetchRequest.predicate = predicate

        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print(error)
        }
        
        return []
    }
    
    static func findFirstOrCreate<T: NSManagedObject>(_ managedObject: T.Type, predicate: NSPredicate, context: NSManagedObjectContext) -> T {
        return self.findFirst(managedObject, predicate: predicate, context: context) ?? T(context: context)
    }
}
