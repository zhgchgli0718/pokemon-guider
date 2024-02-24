//
//  HomeTabBarController.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import UIKit

protocol HomeTabBarControllerDelegate: AnyObject {
    func tabBarDidSelect(_ from: HomeTabBarController, didSelect viewController: UIViewController, index: Int)
}

final class HomeTabBarController: UITabBarController {
    
    weak var homeTabBarConrollerDelegate: HomeTabBarControllerDelegate?
    
    override func viewDidLoad() {
        layoutUI()
        
        delegate = self
    }
}

extension HomeTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        homeTabBarConrollerDelegate?.tabBarDidSelect(self, didSelect: viewController, index: selectedIndex)
    }
}

private extension HomeTabBarController {
    func layoutUI() {
        view.backgroundColor = .white
    }
}
