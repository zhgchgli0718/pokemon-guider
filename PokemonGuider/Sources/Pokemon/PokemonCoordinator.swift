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
        let viewModel = PokemonListViewModel()
        viewModel.delegate = self
        let pokemonListViewController = PokemonListViewController(viewModel: viewModel)
        navigationController.setViewControllers([pokemonListViewController], animated: false)
    }
}

private extension PokemonCoordinator {
    func goToPokemonDetail(id: String) {
        let viewModel = PokemonDetailViewModel(id: id)
        viewModel.delegate = self
        let pokemonDetailViewController = PokemonDetailViewController(viewModel: viewModel)
        pokemonDetailViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(pokemonDetailViewController, animated: true)
    }
}

extension PokemonCoordinator: PokemonListViewModelDekegate {
    func pokemonListViewModel(_ viewModel: PokemonListViewModel, pokemonDidTap id: String) {
        goToPokemonDetail(id: id)
    }
}

extension PokemonCoordinator: PokemonDetailViewModelDelegate {
    func pokemonDetailViewModel(_ viewModel: PokemonDetailViewModel, pokemonDidTap id: String) {
        goToPokemonDetail(id: id)
    }
}
