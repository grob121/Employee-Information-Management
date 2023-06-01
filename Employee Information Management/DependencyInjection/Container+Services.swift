import Swinject
import SwinjectAutoregistration

extension Container {
    func registerServices() {
        autoregister(AuthenticateService.self, initializer: AuthenticateService.init).inObjectScope(.container)
        autoregister(JsonService.self, initializer: JsonService.init).inObjectScope(.container)
    }
}
