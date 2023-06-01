import Foundation
import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()
    private var window = UIWindow(frame: UIScreen.main.bounds)
    
    override func start() {
        window.makeKeyAndVisible()
        showLogin()
    }
    
    private func showLogin() {
        removeChildCoordinators()
        let coordinator = AppDelegate.container.resolve(LoginCoordinator.self)!
        start(coordinator: coordinator)
        
        window.rootViewController = coordinator.navigationController
        window.makeKeyAndVisible()
    }
    
    private func showEmployeeList() {
        removeChildCoordinators()
        let coordinator = AppDelegate.container.resolve(EmployeeListCoordinator.self)!
        coordinator.navigationController = UINavigationController()
        start(coordinator: coordinator)
        
        window.rootViewController = coordinator.navigationController
        window.makeKeyAndVisible()
    }
}
