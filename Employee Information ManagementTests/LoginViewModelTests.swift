import XCTest
@testable import Employee_Information_Management

class LoginViewModelTests: XCTestCase {
    let authenticateService = AuthenticateService()
    let credentials = Credentials(companyName: "Accenture", password: "accenture123")
    var initialLogin = false
    var viewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel(authenticateService: authenticateService)
        initialLogin = viewModel.isLogin
    }
    
    func test_login_state() {
        viewModel.login()
        XCTAssertNotEqual(initialLogin, viewModel.isLogin)
    }
    
    func test_authenticate_service() {
        XCTAssertEqual(authenticateService.verifyAccount(credentials: credentials), true)
    }
}
