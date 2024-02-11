import Foundation

public enum HTTPMethod: String {
    case GET
//    case POST
}



protocol EndpointType {
    var path: EndpointPath { get }
    var method: HTTPMethod { get }
}

struct Endpoint: EndpointType {
    var path: EndpointPath
    var method: HTTPMethod = .GET
    
    func makeURL(for cityName: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/\(path)"
        components.queryItems = [
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: "79b3683f2a693bab81b3a7c8731ab2ae"),
            URLQueryItem(name: "q", value: cityName)
        ]
        return components.url
    }
}


func decode<T: Decodable>(into type: T.Type, data: Data) throws -> T {
    try JSONDecoder().decode(type, from: data)
}


protocol RepositoryType {
    func getForecast(for cityName: String) async throws -> [WeatherModel]
    func clearCache()
}

final class Repository: RepositoryType {

    func clearCache() {
    }

    func getForecast(for cityName: String) async throws -> [WeatherModel] {
        // Endpoint
        let endpoint = Endpoint(path: .forecast)
        
        
        // URL
        guard let url = endpoint.makeURL(for: cityName) else {
            throw WeatherAppError.RequestError.cannotBuildValidURL(path: endpoint.path.rawValue, method: endpoint.method)
        }
        
        // Request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Response
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let forecastResponse = try decode(into: ForecastResponse.self, data: data)
            let weatherModel = WeatherModel.makeForecast(from: forecastResponse)
            
            return weatherModel
        } catch {
            throw WeatherAppError.DecodeError.cannotDecodeData
        }
    }
    
    func getCurrentWeather(for cityName: String) async throws -> WeatherModel {
        // Endpoint
        let endpoint = Endpoint(path: .weather)
        
        // URL
        guard let url = endpoint.makeURL(for: cityName) else {
            throw WeatherAppError.RequestError.cannotBuildValidURL(path: endpoint.path.rawValue, method: endpoint.method)
        }
        
        let repo = ForecastRepository()
        Task { @MainActor in
            try await repo.getForecast(for: cityName)
        }
        
        // Request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Response
        let (data, _) = try await URLSession.shared.data(for: request)
        
        
        do {
            let currentResponse = try decode(into: CurrentResponse.self, data: data)
            let weatherModel = WeatherModel.makeCurrent(from: currentResponse)
            
            return weatherModel
        } catch {
            throw WeatherAppError.DecodeError.cannotDecodeData
        }
    }
}
