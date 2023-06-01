import Foundation
import RxSwift
import UIKit

class LoginCoordinator: BaseCoordinator {
    private let loginViewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
    }
    
    override func start() {
        let viewController = LoginViewController.instantiate()
        viewController.viewModel = loginViewModel
        
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [viewController]
        
        if UserDefaults.standard.object(forKey: "companyName") != nil {
            showEmployeeList()
        } else {
            loginViewModel.isLoginSuccess
                .subscribe(onNext: { [weak self] isLoginSuccess in
                    if isLoginSuccess {
                        self?.loginViewModel.companyName
                            .subscribe(onNext: { companyName in
                                UserDefaults.standard.set(companyName, forKey: "companyName")
                            })
                            .disposed(by: self?.disposeBag ?? DisposeBag())
                        self?.showEmployeeList()
                    } else {
                        if let isLogin = self?.loginViewModel.isLogin, isLogin {
                            self?.showLoginError()
                            self?.loginViewModel.isLogin = false
                        }
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    func showEmployeeList() {
        removeChildCoordinators()
        let coordinator = AppDelegate.container.resolve(EmployeeListCoordinator.self)!
        coordinator.navigationController = navigationController
        start(coordinator: coordinator)
    }
    
    private func showLoginError() {
        let alert = UIAlertController(title: "Login Error", message: "Company name or password is incorrect", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        navigationController.viewControllers.first?.present(alert, animated: false)
    }
}
