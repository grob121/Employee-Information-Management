import Foundation
import RxSwift

class EmployeeListViewModel {
    let jsonService: JsonService
    let title = "Employee List"
    let employees = BehaviorSubject(value: [String]())
    
    private let disposeBag = DisposeBag()
    
    init(loginViewModel: LoginViewModel, jsonService: JsonService) {
        self.jsonService = jsonService
        
        UserDefaults.standard.rx
            .observe(String.self, "companyName")
            .subscribe(onNext: { [weak self] (value) in
                if let value = value {
                    loginViewModel.companyName
                        .subscribe { [weak self] companyName in
                            self?.employees.onNext(self?.jsonService.readEmployeeData(jsonName: value) ?? [])
                        }
                        .disposed(by: self?.disposeBag ?? DisposeBag())
                }
            })
            .disposed(by: disposeBag)
    }
}
