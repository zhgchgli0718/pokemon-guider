//
//  SaveToCoreDataVisitor.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/27.
//

import Foundation
import CoreData

// 使用 Design Pattern - Visitor Pattern 進行抽象
// 因 Model 有多個 x 儲存方式及策略未來也有可能是多個 組合
class SaveToCoreDataVisitor: SaveableVisitor {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func visit(_ model: PokemonDetailModel) {
        let predicate = NSPredicate(format: "id == %@", model.id)
        var managedObject = CoreDataManager.findFirstOrCreate(PokemonDetailManagedObject.self, predicate: predicate, context: context)
        managedObject.id = model.id
        managedObject.name = model.name
        managedObject.owned = model.owned
        managedObject.coverImage = model.coverImage
        managedObject.images = model.images
        
        let predicateDetail = NSPredicate(format: "detail == %@", managedObject)
        managedObject.types = NSSet(array: model.types.map({ type in
            let typeManagedObject = CoreDataManager.findFirstOrCreate(PokemonDetailTypeManagedObject.self, predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [predicateDetail, NSPredicate(format: "name == %@", type.name)]), context: context)
            typeManagedObject.name = type.name
            typeManagedObject.url = type.url
            return typeManagedObject
        }))
        managedObject.stats = NSSet(array: model.stats.map({ stat in
            let statManagedObject = CoreDataManager.findFirstOrCreate(PokemonDetailStatManagedObject.self, predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [predicateDetail, NSPredicate(format: "name == %@", stat.name)]), context: context)
            statManagedObject.name = stat.name
            statManagedObject.url = stat.url
            statManagedObject.baseStat = Int32(stat.baseStat)
            statManagedObject.effort = Int32(stat.effort)
            return statManagedObject
        }))
        CoreDataManager.save(context: context)
    }
}

