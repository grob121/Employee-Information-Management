import Foundation
import UIKit

class EmployeeListCoordinator: BaseCoordinator {
    private let employeeListViewModel: EmployeeListViewModel
    private let jsonService: JsonService
    
    init(employeeListViewModel: EmployeeListViewModel, jsonService: JsonService) {
        self.employeeListViewModel = employeeListViewModel
        self.jsonService = jsonService
    }
    
    override func start() {
        let viewController = EmployeeListViewController.instantiate()
        viewController.viewModel = employeeListViewModel
        
        navigationController.isNavigationBarHidden = false
        navigationController.viewControllers = [viewController]
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddAlert))
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(showLogoutAlert))
    }
    
    @objc private func showAddAlert() {
        let alert = UIAlertController(title: "Add Employee", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self, weak alert] (_) in
            let textField = alert?.textFields?[0]
            if let employeeName = textField?.text, !employeeName.isEmpty, let companyName = UserDefaults.standard.object(forKey: "companyName") as? String {
                var employees =  self?.jsonService.readEmployeeData(jsonName: companyName)
                employees?.append(employeeName)
                self?.jsonService.writeEmployeeData(employees: employees ?? [], jsonName: companyName)
                self?.employeeListViewModel.employees.onNext(employees ?? [])
            }
        }))
        
        navigationController.viewControllers.first?.present(alert, animated: true, completion: nil)
    }
    
    @objc private func showLogoutAlert() {
        let alert = UIAlertController(title: "Are you sure you want to logout?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            self.showLogin()
        })
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        navigationController.viewControllers.first?.present(alert, animated: true, completion: nil)
    }
    
    private func showLogin() {
        UserDefaults.standard.removeObject(forKey: "companyName")

        removeChildCoordinators()
        let coordinator = AppDelegate.container.resolve(LoginCoordinator.self)!
        coordinator.navigationController = navigationController
        start(coordinator: coordinator)
    }
}
