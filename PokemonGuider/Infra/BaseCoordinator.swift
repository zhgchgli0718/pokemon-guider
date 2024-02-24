//
//  BaseCoordinator.swift
//  PokemonGuider
//
//  Created by zhgchgli on 2024/2/24.
//

import Foundation

class BaseCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
  
    func start() {
        //
    }
  
    func add(child coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
  
    func remove(child coordinator: Coordinator?) {
        guard childCoordinators.isEmpty == false,
              let coordinator = coordinator
        else { return }
    
        if let coordinator = coordinator as? BaseCoordinator,
           !coordinator.childCoordinators.isEmpty {
            coordinator.childCoordinators.filter({ $0 !== coordinator }).forEach({ coordinator.remove(child: $0) })
        }
        
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}
