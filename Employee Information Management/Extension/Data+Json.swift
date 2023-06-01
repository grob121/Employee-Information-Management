import Foundation

struct VoidResponse: Codable { }

enum Json {
    static let decoder = JSONDecoder()
}

extension Data {
    func toObject<T:Codable>(_ type: T.Type) -> T? {
        if type == VoidResponse.self {
            return VoidResponse() as? T
        }
        return try? Json.decoder.decode(type, from: self)
    }
}
