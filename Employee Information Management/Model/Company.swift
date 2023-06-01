import Foundation

struct Company: Codable {
    let accounts: [Account]
}

struct Account: Codable {
    let companyName: String
    let password: String
}
