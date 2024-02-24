//
//  UIImageView+Extension.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import NukeExtensions
import UIKit

extension UIImageView {
    func setImage(url: URL) {
        NukeExtensions.loadImage(with: url, options: .shared, into: self)
    }
}
