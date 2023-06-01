import XCTest
@testable import Employee_Information_Management

class EmployeeListViewModelTests: XCTestCase {
    let jsonService = JsonService()
    let jsonName = "JsonServiceTest"
    let employees = ["Alpha","Beta","Charlie","Delta","Epsilon"]
    var viewModel: EmployeeListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = EmployeeListViewModel(loginViewModel: LoginViewModel(authenticateService: AuthenticateService()), jsonService: jsonService)
        jsonService.writeEmployeeData(employees: employees, jsonName: jsonName)
    }
    
    func test_read_write_json_service() {
        XCTAssertEqual( jsonService.readEmployeeData(jsonName: jsonName), employees)
    }
    
    func test_navigation_title() {
        XCTAssertEqual(viewModel.title, "Employee List")
    }
}
