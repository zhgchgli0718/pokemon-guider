//
//  MyProfileCoordinator.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import UIKit

final class MyProfileCoordinator: Coordinator {
        
    private let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
  
    func start() {
        let myProfileViewController = MyProfileViewController()
        navigationController.setViewControllers([myProfileViewController], animated: false)
    }
}

