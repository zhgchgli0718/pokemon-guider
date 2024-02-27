//
//  SaveToCoreDataVisitor.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/27.
//

import Foundation
import CoreData

class SaveToCoreDataVisitor: SaveableVisitor {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func visit(_ model: PokemonDetailModel) {
        let predicate = NSPredicate(format: "id == %@", model.id)
        var managedObject = CoreDataManager.findFirstOrCreate(PokemonDetailManagedObject.self, predicate: predicate, context: context)
        model.configure(&managedObject, context: context)
        CoreDataManager.save(context: context)
    }
}

