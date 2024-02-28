//
//  PokemonCoordinator.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import UIKit

protocol PokemonCoordinatorSpec: Coordinator {
    func goToPokemonDetail(id: String)
}

final class PokemonCoordinator: PokemonCoordinatorSpec {
        
    private let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
  
    func start() {
        let viewModel = PokemonListViewModel()
        viewModel.delegate = self
        let pokemonListViewController = PokemonListViewController(viewModel: viewModel)
        navigationController.setViewControllers([pokemonListViewController], animated: false)
    }
}

extension PokemonCoordinator {
    func goToPokemonDetail(id: String) {
        let viewModel = PokemonDetailViewModel(id: id)
        viewModel.delegate = self
        let pokemonDetailViewController = PokemonDetailViewController(viewModel: viewModel)
        pokemonDetailViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(pokemonDetailViewController, animated: true)
    }
}

extension PokemonCoordinator: PokemonListViewModelDelegate {
    func pokemonListViewModel(_ viewModel: PokemonListViewModelSpec, pokemonDidTap id: String) {
        goToPokemonDetail(id: id)
    }
}

extension PokemonCoordinator: PokemonDetailViewModelDelegate {
    func pokemonDetailViewModel(_ viewModel: PokemonDetailViewModelSpec, pokemonDidTap id: String) {
        goToPokemonDetail(id: id)
    }
}
