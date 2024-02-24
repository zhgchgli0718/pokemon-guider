//
//  MyProfileCoordinator.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import UIKit

final class MyProfileCoordinator: BaseCoordinator {
        
    private let navigationController: UINavigationController
  
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
  
    override func start() {
        let myProfileViewController = MyProfileViewController()
        navigationController.viewControllers = [myProfileViewController]
    }
}

