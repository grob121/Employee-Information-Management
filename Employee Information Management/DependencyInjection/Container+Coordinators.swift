import Swinject
import SwinjectAutoregistration

extension Container {
    func registerCoordinators() {
        autoregister(AppCoordinator.self, initializer: AppCoordinator.init)
        autoregister(LoginCoordinator.self, initializer: LoginCoordinator.init)
        autoregister(EmployeeListCoordinator.self, initializer: EmployeeListCoordinator.init)
    }
}
