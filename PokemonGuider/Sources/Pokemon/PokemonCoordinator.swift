//
//  PokemonCoordinator.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import UIKit

final class PokemonCoordinator: BaseCoordinator {
        
    private let navigationController: UINavigationController
  
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
  
    override func start() {
        let pokemonListViewController = PokemonListViewController()
        navigationController.setViewControllers([pokemonListViewController], animated: false)
    }
}
