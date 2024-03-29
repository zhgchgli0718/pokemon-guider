//
//  HomeCoordinator.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import UIKit

final class HomeCoordinator: Coordinator {
        
    private let homeTabBarController: HomeTabBarController
    var childCoordinators: [Coordinator] = []
    
    init(homeTabBarController: HomeTabBarController) {
        self.homeTabBarController = homeTabBarController
        homeTabBarController.homeTabBarConrollerDelegate = self
    }
  
    func start() {
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
                navigationController.title = NSLocalizedString("pokemon_list", comment: "所有寶可夢")
                navigationController.tabBarItem.image = UIImage(systemName: "lizard.circle")
                navigationController.navigationBar.prefersLargeTitles = true
                navigationController.tabBarItem.accessibilityIdentifier = "pokemonList"
                return (navigationController, coordinator)
            case .myProfile:
                let navigationController = UINavigationController()
                let coordinator = MyProfileCoordinator(navigationController: navigationController)
                navigationController.title = NSLocalizedString("my_profile", comment: "我的帳戶")
                navigationController.tabBarItem.image = UIImage(systemName: "person.crop.circle")
                navigationController.tabBarItem.accessibilityIdentifier = "myProfile"
                return (navigationController, coordinator)
            }
        }
    }
}

extension HomeCoordinator: HomeTabBarControllerDelegate {
    func tabBarDidSelect(_ from: HomeTabBarController, didSelect viewController: UIViewController, index: Int) {
        guard (viewController as? UINavigationController)?.viewControllers.isEmpty ?? false == true else {
            return
        }
        childCoordinators[index].start()
    }
}
