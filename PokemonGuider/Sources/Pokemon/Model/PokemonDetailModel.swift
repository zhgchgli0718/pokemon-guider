//
//  PokemonDetailModel.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/25.
//

import Foundation
import CoreData

final class PokemonDetailModel {
    let id: String
    let name: String
    let types: [PokemonType]
    let coverImage: String?
    let images: [String]
    let stats: [Stat]
    var owned: Bool
    
    init(entity: PokemonDetailEntity) {
        self.id = String(entity.id)
        self.name = entity.name
        self.types = entity.types.map { PokemonType(name: $0.type.name, url: $0.type.url) }
        self.owned = false
        self.coverImage = entity.sprites.front_default
        self.images = [
            entity.sprites.back_default,
            entity.sprites.back_female,
            entity.sprites.back_shiny,
            entity.sprites.back_shiny_female,
            entity.sprites.front_default,
            entity.sprites.front_female,
            entity.sprites.front_shiny,
            entity.sprites.front_shiny_female
        ].compactMap { $0 }
        self.stats = entity.stats.map { Stat(name: $0.stat.name, url: $0.stat.url, baseStat: $0.base_stat, effort: $0.effort) }
    }
    
    init(managedObject: PokemonDetailManagedObject) {
        self.id = managedObject.id ?? ""
        self.name = managedObject.name ?? ""
        self.owned = managedObject.owned
        self.coverImage = managedObject.coverImage
        self.types = managedObject.types?.compactMap({ element -> PokemonDetailModel.PokemonType? in
            guard let type = element as? PokemonDetailTypeManagedObject,
                  let name = type.name,
                  let url =  type.url else {
                return nil
            }
            return PokemonDetailModel.PokemonType(name: name, url: url)
        }) ?? []
        self.images = managedObject.images ?? []
        self.stats = managedObject.types?.compactMap({ element -> PokemonDetailModel.Stat?  in
            guard let stat = element as? PokemonDetailStatManagedObject,
                  let name = stat.name,
                  let url =  stat.url else {
                return nil
            }
            return PokemonDetailModel.Stat(name: name, url: url, baseStat: Int(stat.baseStat), effort: Int(stat.effort))
        }) ?? []
    }
}


extension PokemonDetailModel: Saveable {
    func accept(visitor: SaveableVisitor) {
        visitor.visit(self)
    }
    
    func configure(_ managedObject: inout PokemonDetailManagedObject, context: NSManagedObjectContext) {
        managedObject.id = id
        managedObject.name = name
        managedObject.owned = owned
        managedObject.coverImage = coverImage
        managedObject.images = images
        
        let predicateDetail = NSPredicate(format: "detail == %@", managedObject)
        managedObject.types = NSSet(array: types.map({ type in
            let typeManagedObject = CoreDataManager.findFirstOrCreate(PokemonDetailTypeManagedObject.self, predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [predicateDetail, NSPredicate(format: "name == %@", type.name)]), context: context)
            typeManagedObject.name = type.name
            typeManagedObject.url = type.url
            return typeManagedObject
        }))
        managedObject.stats = NSSet(array: stats.map({ stat in
            let statManagedObject = CoreDataManager.findFirstOrCreate(PokemonDetailStatManagedObject.self, predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [predicateDetail, NSPredicate(format: "name == %@", stat.name)]), context: context)
            statManagedObject.name = stat.name
            statManagedObject.url = stat.url
            statManagedObject.baseStat = Int32(stat.baseStat)
            statManagedObject.effort = Int32(stat.effort)
            return statManagedObject
        }))
    }
}

extension PokemonDetailModel {
    class PokemonType {
        let name: String
        let url: String
        init(name: String, url: String) {
            self.name = name
            self.url = url
        }
    }
    
    class Stat: Decodable {
        let name: String
        let url: String
        let baseStat: Int
        let effort: Int
        init(name: String, url: String, baseStat: Int, effort: Int) {
            self.name = name
            self.url = url
            self.baseStat = baseStat
            self.effort = effort
        }
    }
}
