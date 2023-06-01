import Foundation
import RxSwift

class LoginViewModel {
    let companyName = BehaviorSubject<String>(value: "")
    let password = BehaviorSubject<String>(value: "")
    let isLoginSuccess = BehaviorSubject<Bool>(value: false)
    let isLoginActive = BehaviorSubject<Bool>(value: false)
    var isLogin = false
    
    private let authenticateService: AuthenticateService
    private let disposeBag = DisposeBag()
    
    init(authenticateService: AuthenticateService) {
        self.authenticateService = authenticateService
        setUpBindings()
    }
    
    func login() {
        isLogin = true
        
        Observable
            .combineLatest(companyName, password, isLoginActive)
            .take(1)
            .filter { _, _, active in active }
            .map { companyName, password, _ in self.authenticateService.verifyAccount(credentials: Credentials(companyName: companyName, password: password)) }
            .subscribe { isLoginSuccess in self.isLoginSuccess.onNext(isLoginSuccess) }
            .disposed(by: disposeBag)
    }
    
    private func setUpBindings() {
        Observable
            .combineLatest(companyName, password)
            .map { $0.trimmingCharacters(in: CharacterSet.whitespaces) != "" && $1.trimmingCharacters(in: CharacterSet.whitespaces) != "" }
            .bind(to: isLoginActive)
            .disposed(by: disposeBag)
    }
}
