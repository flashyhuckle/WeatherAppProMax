import Foundation

enum EndpointPath: String {
    case forecast
    case weather
}

protocol OpenWeatherAPIType {
    func getWeather<T: Decodable>(
        path: EndpointPath,
        city: String,
        decoder: JSONDecoder,
        as: T.Type,
        apiKey: String
    ) async throws -> T
}

extension OpenWeatherAPIType {
    func getWeather<T: Decodable>(
        path: EndpointPath,
        city: String,
        decoder: JSONDecoder = JSONDecoder(),
        as: T.Type,
        apiKey: String = Bundle.main.apiKey
    ) async throws -> T {
        try await getWeather(path: path, city: city, decoder: decoder, as: T.self, apiKey: apiKey)
    }
}
