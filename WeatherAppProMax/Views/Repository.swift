import Foundation

enum HTTPRequestError: Error {
    case cannotBuildValidURL(path: String, method: HTTPMethod)
}

enum DecodeError: Error {
    case cannotDecodeData
}

public enum HTTPMethod: String {
    case GET
    case POST
}

protocol EndpointType {
    var url: URL? { get }
    var method: HTTPMethod { get }
}


func decode<T: Decodable>(into type: T.Type, data: Data) throws -> T {
    try JSONDecoder().decode(type, from: data)
}

struct ForecastEndpoint: EndpointType {
    
    var url: URL?
    var method: HTTPMethod = .GET

    init(
        cityName: String
    ) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/forecast"
        components.queryItems = [
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "cnt", value: "5"),
            URLQueryItem(name: "appid", value: "79b3683f2a693bab81b3a7c8731ab2ae")
        ]
        components.queryItems?.append(
            URLQueryItem(name: "q", value: cityName)
        )
        url = components.url
    }
}

struct CurrentEndpoint: EndpointType {
    
    var url: URL?
    var method: HTTPMethod = .GET

    init(
        cityName: String
    ) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: "79b3683f2a693bab81b3a7c8731ab2ae")
        ]
        components.queryItems?.append(
            URLQueryItem(name: "q", value: cityName)
        )
        url = components.url
    }
}



protocol WeatherRepositoryType {
    func getForecast(for cityName: String) async throws -> [WeatherModel]
    func clearCache()
}

final class WeatherRepository: WeatherRepositoryType {

    func clearCache() {
    }

    func getForecast(for cityName: String) async throws -> [WeatherModel] {
        // Endpoint
        let endpoint = ForecastEndpoint(cityName: cityName)
        
        // URL
        guard let url = endpoint.url else {
            // 🚨 Handle base url
            throw HTTPRequestError.cannotBuildValidURL(path: endpoint.url?.absoluteString ?? "no path", method: endpoint.method)
        }
        
        print(url.absoluteString)
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
            // 🚨 Handle decoding error
            throw DecodeError.cannotDecodeData
        }
    }
    
    func getCurrentWeather(for cityName: String) async throws -> [WeatherModel] {
        // Endpoint
        let endpoint = CurrentEndpoint(cityName: cityName)
        
        // URL
        guard let url = endpoint.url else {
            // 🚨 Handle base url
            throw HTTPRequestError.cannotBuildValidURL(path: endpoint.url?.absoluteString ?? "no path", method: endpoint.method)
        }
        print(url.absoluteString)
        // Request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Response
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let currentResponse = try decode(into: CurrentResponse.self, data: data)
            let weatherModel = WeatherModel.makeCurrent(from: currentResponse)
            
            return [weatherModel]
        } catch {
            // 🚨 Handle decoding error
            throw DecodeError.cannotDecodeData
        }
    }
}
