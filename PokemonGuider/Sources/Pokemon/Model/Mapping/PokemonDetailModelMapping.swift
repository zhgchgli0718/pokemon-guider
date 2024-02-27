//
//  PokemonDetailModelMapping.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/27.
//

import Foundation
import CoreData

struct PokemonDetailModelMapping {
    static func mapping(entity: PokemonDetailEntity) -> PokemonDetailModel {
        let types = entity.types.map { PokemonDetailModel.PokemonType(name: $0.type.name, url: $0.type.url) }
        let images = [
            entity.sprites.back_default,
            entity.sprites.back_female,
            entity.sprites.back_shiny,
            entity.sprites.back_shiny_female,
            entity.sprites.front_default,
            entity.sprites.front_female,
            entity.sprites.front_shiny,
            entity.sprites.front_shiny_female
        ].compactMap { $0 }
        let stats = entity.stats.map { PokemonDetailModel.Stat(name: $0.stat.name, url: $0.stat.url, baseStat: $0.base_stat, effort: $0.effort) }
        return PokemonDetailModel(id: String(entity.id), name: entity.name, types: types, coverImage: entity.sprites.front_default, images: images, stats: stats, owned: nil)
    }
    
    static func mapping(managedObject: PokemonDetailManagedObject) -> PokemonDetailModel {
        let types = managedObject.types?.compactMap({ element -> PokemonDetailModel.PokemonType? in
            guard let type = element as? PokemonDetailTypeManagedObject,
                  let name = type.name,
                  let url =  type.url else {
                return nil
            }
            return PokemonDetailModel.PokemonType(name: name, url: url)
        }) ?? []
        let images = managedObject.images ?? []
        let stats = managedObject.types?.compactMap({ element -> PokemonDetailModel.Stat?  in
            guard let stat = element as? PokemonDetailStatManagedObject,
                  let name = stat.name,
                  let url =  stat.url else {
                return nil
            }
            return PokemonDetailModel.Stat(name: name, url: url, baseStat: Int(stat.baseStat), effort: Int(stat.effort))
        }) ?? []
        return PokemonDetailModel(id: managedObject.id ?? "", name: managedObject.name ?? "", types: types, coverImage: managedObject.coverImage, images: images, stats: stats, owned: managedObject.owned)
    }
}
