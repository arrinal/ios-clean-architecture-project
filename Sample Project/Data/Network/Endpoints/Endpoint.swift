import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var queryItems: [URLQueryItem] {
        []
    }
}
