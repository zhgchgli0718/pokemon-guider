//
//  NSObject+Extension.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
