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
    
    private let modelName = "PokemonGuider"
    
    private override init() {
        
    }
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        
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
    
    private var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    public static var defaultBackgroundContext: NSManagedObjectContext {
        return Self.newBackgroundContext()
    }
    
    static var viewContext: NSManagedObjectContext {
        return CoreDataManager.shared.viewContext
    }
    
    static func save(context: NSManagedObjectContext?) {
        guard let context = context else {
            print("No context on save")
            return
        }
        
        if context == CoreDataManager.viewContext {
            print("Writing to view context, this should be avoided.")
        }
        
        context.perform {
            if !context.hasChanges { return }
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    static func newBackgroundContext() -> NSManagedObjectContext {
        let backgroundContext = CoreDataManager.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return backgroundContext
    }
}
