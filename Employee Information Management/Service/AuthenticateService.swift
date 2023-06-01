import Foundation
import RxSwift

class AuthenticateService {
    func verifyAccount(credentials: Credentials) -> Bool {
        guard let path = Bundle.main.path(forResource: "companies", ofType: "json") else { return false }
        
        do {
            let json = try String(contentsOfFile: path, encoding: .utf8)
            if let data = json.data(using: .utf8), let company = data.toObject(Company.self) {
                for account in company.accounts {
                    if account.companyName == credentials.companyName && account.password == credentials.password {
                        return true
                    }
                }
            }
        } catch {
            return false
        }
        
        return false
    }
}
