//
//  AppCoordinator.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation
import UIKit

final class AppCoordinator: BaseCoordinator {
    
    private(set) var window: UIWindow?
    
    init(scene: UIScene) {
        self.window = Self.configureWindowFor(scene)
        window?.makeKeyAndVisible()
    }
    
    override func start() {
        runDefaultFlow()
    }
}

//
private extension AppCoordinator {
    func runDefaultFlow() {
        let tabBarViewController = HomeTabBarController()
        window?.rootViewController = tabBarViewController
        
        let coordinator = HomeCoordinator(homeTabBarController: tabBarViewController)
        self.add(child: coordinator)
        coordinator.start()
    }
}
private extension AppCoordinator {
    static func configureWindowFor(_ scene: UIScene) -> UIWindow {
        guard let windowScene = (scene as? UIWindowScene) else {
            return UIWindow(frame: UIScreen.main.bounds)
        }

        let window = UIWindow(windowScene: windowScene)

        window.overrideUserInterfaceStyle = .light

        return window
    }
}

