import Foundation

struct JsonService {
    func writeEmployeeData(employees: [String], jsonName: String) -> Void {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("\(jsonName).json")
            try JSONEncoder()
                .encode(employees)
                .write(to: fileURL)
        } catch {
            print("error writing data")
        }
    }
    
    func readEmployeeData(jsonName: String) -> [String] {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("\(jsonName).json")
            
            let data = try Data(contentsOf: fileURL)
            let employeeData = try JSONDecoder().decode([String].self, from: data)
            
            return employeeData
        } catch {
            print("error reading data")
            return []
        }
    }
}

