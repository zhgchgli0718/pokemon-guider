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
        pokemonListViewController.delegate = self
        navigationController.setViewControllers([pokemonListViewController], animated: false)
    }
}

private extension PokemonCoordinator {
    func goToPokemonDetail(id: String) {
        let viewModel = PokemonDetailViewModel(id: id)
        let pokemonDetailViewController = PokemonDetailViewController(viewModel: viewModel)
        pokemonDetailViewController.hidesBottomBarWhenPushed = true
        pokemonDetailViewController.delegate = self
        navigationController.pushViewController(pokemonDetailViewController, animated: true)
    }
}

extension PokemonCoordinator: PokemonListViewControllerDelegate {
    func pokemonListViewController(_ viewController: PokemonListViewController, pokemonDidTap id: String) {
        goToPokemonDetail(id: id)
    }
}

extension PokemonCoordinator: PokemonDetailViewControllerDelegate {
    func pokemonDetailViewController(_ viewController: PokemonDetailViewController, pokemonDidTap id: String) {
        goToPokemonDetail(id: id)
    }
}
