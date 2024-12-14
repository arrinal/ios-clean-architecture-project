import Foundation

struct CityResponse: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    
    var displayName: String {
        if let state = state {
            return "\(name), \(state), \(country)"
        }
        return "\(name), \(country)"
    }
}