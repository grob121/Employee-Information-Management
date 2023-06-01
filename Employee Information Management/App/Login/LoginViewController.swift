import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: LoginViewModel?
    private let disposeBag = DisposeBag()
    
    static func instantiate() -> Self {
        let identifier = String(describing: self)
        let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: identifier) as! Self
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
        configureDismissKeyboard()
    }
    
    private func setUpBindings() {
        guard let viewModel = viewModel else { return }
        
        Observable.of(companyNameTextField, passwordTextField)
            .flatMap { $0.rx.controlEvent(.editingDidEndOnExit) }
            .withLatestFrom(viewModel.isLoginActive)
            .filter { $0 }
            .bind { [weak self] _ in self?.viewModel?.login() }
            .disposed(by: disposeBag)
        
        companyNameTextField.rx.text.orEmpty
            .bind(to: viewModel.companyName)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind { [weak self] in self?.viewModel?.login() }
            .disposed(by: disposeBag)
        
        viewModel.isLoginActive
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

