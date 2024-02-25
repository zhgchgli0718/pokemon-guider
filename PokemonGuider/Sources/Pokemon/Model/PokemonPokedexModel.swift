//
//  PokemonPokedexModel.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/25.
//

import Foundation

final class PokemonPokedexModel {
    let descriptions: [Description]
    var currentLanguageDescription: Description? {
        var language = Locale.current.language.languageCode?.identifier ?? "en"
        
        if let matchLanguage = descriptions.first(where: { $0.language.name == language }) {
            return matchLanguage
        }
        
        language = "en"
        if let matchLanguage = descriptions.first(where: { $0.language.name == language }) {
            return matchLanguage
        }
        
        return descriptions.first
    }
    
    init(entity: PokemonPokedexEntity) {
        self.descriptions = entity.descriptions.map { Description(description: $0.description, language: .init(name: $0.language.name, url: $0.language.url)) }
    }
}

extension PokemonPokedexModel {
    class Description {
        class Language {
            let name: String
            let url: String
            
            init(name: String, url: String) {
                self.name = name
                self.url = url
            }
        }
        let description: String
        let language: Language
        
        init(description: String, language: Language) {
            self.description = description
            self.language = language
        }
    }
}
