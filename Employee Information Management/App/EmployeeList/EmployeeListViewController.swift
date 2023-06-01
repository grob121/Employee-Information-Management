import Foundation
import UIKit
import RxSwift
import RxCocoa

class EmployeeListViewController: UIViewController {
    @IBOutlet weak var employeeTableView: UITableView!
    var viewModel: EmployeeListViewModel?
    
    private let disposeBag = DisposeBag()
    
    static func instantiate() -> Self {
        let identifier = String(describing: self)
        let viewController = UIStoryboard(name: "EmployeeList", bundle: nil).instantiateViewController(withIdentifier: identifier) as! Self
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        guard let viewModel = viewModel else { return }
        
        title = viewModel.title
        
        viewModel.employees
            .bind(to: employeeTableView.rx.items(cellIdentifier: "employeeCell")) { row, model, cell in
                cell.textLabel?.text = model
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        Observable
            .zip(employeeTableView.rx.itemSelected, employeeTableView.rx.modelSelected(String.self))
            .bind { [unowned self] indexPath, model in
                self.showEditAlert(row: indexPath.row, name: model)
            }
            .disposed(by: disposeBag)
        }
    
    
    @objc private func showEditAlert(row: Int, name: String) {
        let alert = UIAlertController(title: "Edit Employee", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.text = name
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self, weak alert] (_) in
            let textField = alert?.textFields?[0]
            if let employeeName = textField?.text, !employeeName.isEmpty, let companyName = UserDefaults.standard.object(forKey: "companyName") as? String {
                var employees =  self?.viewModel?.jsonService.readEmployeeData(jsonName: companyName)
                employees?[row] = textField?.text ?? ""
                self?.viewModel?.jsonService.writeEmployeeData(employees: employees ?? [], jsonName: companyName)
                self?.viewModel?.employees.onNext(employees ?? [])
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Mark as Resigned", style: .destructive, handler: { [weak self] (_) in
            if let companyName = UserDefaults.standard.object(forKey: "companyName") as? String {
                var employees = self?.viewModel?.jsonService.readEmployeeData(jsonName: companyName)
                employees?.remove(at: row)
                self?.viewModel?.jsonService.writeEmployeeData(employees: employees ?? [], jsonName: companyName)
                self?.viewModel?.employees.onNext(employees ?? [])
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}


