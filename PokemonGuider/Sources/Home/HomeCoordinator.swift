//
//  HomeCoordinator.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import UIKit

final class HomeCoordinator: BaseCoordinator {
        
    private let homeTabBarController: HomeTabBarController
  
    init(homeTabBarController: HomeTabBarController) {
        self.homeTabBarController = homeTabBarController
        super.init()
    }
  
    override func start() {
        runDefaultFlow([.pokemonList, .myProfile])
    }
}

private extension HomeCoordinator {
    func runDefaultFlow(_ items: [TabItem]) {
        let dataSource = items.map({ $0.makeCoordinator() })
        let viewControllers  = dataSource.map({ $0.navigationController })
        let coordinators  = dataSource.map({ $0.coordinator })
        
        homeTabBarController.viewControllers = viewControllers
        childCoordinators.forEach({ remove(child: $0) })
        coordinators.forEach({ add(child: $0) })
        coordinators.first?.start()
    }
}

private extension HomeCoordinator {
    enum TabItem {
        case pokemonList
        case myProfile
        
        func makeCoordinator() -> (navigationController: UINavigationController, coordinator: Coordinator) {
            switch self {
            case .pokemonList:
                let navigationController = UINavigationController()
                let coordinator = PokemonCoordinator(navigationController: navigationController)
                navigationController.title = NSLocalizedString("pokemon_list", comment: "寶可夢")
                navigationController.tabBarItem.image = UIImage(systemName: "lizard.circle")
                return (navigationController, coordinator)
            case .myProfile:
                let navigationController = UINavigationController()
                let coordinator = MyProfileCoordinator(navigationController: navigationController)
                navigationController.title = NSLocalizedString("my_profile", comment: "我的帳戶")
                navigationController.tabBarItem.image = UIImage(systemName: "person.crop.circle")
                return (navigationController, coordinator)
            }
        }
    }
}