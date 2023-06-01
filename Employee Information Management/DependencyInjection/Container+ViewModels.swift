import Foundation
import Swinject
import SwinjectAutoregistration

extension Container {
    func registerViewModels() {
        autoregister(LoginViewModel.self, initializer: LoginViewModel.init)
        autoregister(EmployeeListViewModel.self, initializer: EmployeeListViewModel.init)
    }
}
