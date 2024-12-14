import Foundation
import Combine

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(String)
    case decodingFailed(String)
    case serverError(code: Int, message: String)
    case emptyResponse
    case invalidRequestBody
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let message):
            return "Request failed: \(message)"
        case .decodingFailed(let message):
            return "Decoding failed: \(message)"
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message)"
        case .emptyResponse:
            return "Empty response from server"
        case .invalidRequestBody:
            return "Invalid request body"
        }
    }
}

protocol BaseService {
    var baseURL: String { get }
    func request<T: Codable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError>
    func request<T: Codable, B: Encodable>(_ endpoint: Endpoint, body: B?) -> AnyPublisher<T, NetworkError>
}

extension BaseService {
    var baseURL: String { "http://localhost:8080/api/v1" }
    
    func request<T: Codable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        request(endpoint, body: Optional<String>.none)
    }
    
    func request<T: Codable, B: Encodable>(_ endpoint: Endpoint, body: B?) -> AnyPublisher<T, NetworkError> {
        var components = URLComponents(string: baseURL + endpoint.path)
        components?.queryItems = endpoint.queryItems
        
        guard let url = components?.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                request.httpBody = try encoder.encode(body)
            } catch {
                return Fail(error: NetworkError.invalidRequestBody).eraseToAnyPublisher()
            }
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error -> NetworkError in
                .requestFailed(error.localizedDescription)
            }
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.requestFailed("Invalid response")
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    if let errorResponse = try? decoder.decode(BaseServiceResponse<String>.self, from: data) {
                        throw NetworkError.serverError(code: errorResponse.code, message: errorResponse.message)
                    }
                    throw NetworkError.serverError(code: httpResponse.statusCode, message: "Unknown error")
                }
                
                return data
            }
            .decode(type: BaseServiceResponse<T>.self, decoder: decoder)
            .tryMap { response -> T in
                guard let data = response.data else {
                    throw NetworkError.emptyResponse
                }
                return data
            }
            .mapError { error -> NetworkError in
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.decodingFailed(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
