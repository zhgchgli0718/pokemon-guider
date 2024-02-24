//
//  HomeTabBarController.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import UIKit

final class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        layoutUI()
    }
}

private extension HomeTabBarController {
    func layoutUI() {
        view.backgroundColor = .white
    }
}
