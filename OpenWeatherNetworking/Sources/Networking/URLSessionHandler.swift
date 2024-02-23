import Foundation
import WeatherAppError

public class URLSessionHandler: URLSessionHandlerType {
    private let baseURL: URL
    private let session: URLSession
    
    public init(
        baseURL: URL = Bundle.main.apiBaseUrl,
        session: URLSession = URLSession(
            configuration: .default
        )
    ) {
        self.baseURL = baseURL
        self.session = session
    }
    
    public func performRequest(
        path: String,
        query: [String: String]? = nil
    ) async throws -> Data {
        var url = baseURL.appending(path: path)
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            if let query {
                components.queryItems = query.map { URLQueryItem(name: $0, value: $1) }
            }
            
            if let resultUrl = components.url {
                url = resultUrl
            } else {
                throw WeatherAppError.RequestError.cannotBuildValidURL(path: path)
            }
        }
        
        let request = URLRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw WeatherAppError.RequestError.badResponse
        }
        
        switch response.statusCode {
        case 401:
            throw WeatherAppError.RequestError.unauthorized
        case 400..<500:
            throw WeatherAppError.RequestError.clientError(statusCode: response.statusCode)
        case 500...:
            throw WeatherAppError.RequestError.serverError(statusCode: response.statusCode)
        default:
            break
        }
        
        return data
    }
}
