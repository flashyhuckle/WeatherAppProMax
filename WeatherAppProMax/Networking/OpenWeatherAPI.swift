import Foundation

class OpenWeatherAPI {
    private let handler: URLSessionHandlerType
    
    init(
        handler: URLSessionHandlerType = URLSessionHandler()
    ) {
        self.handler = handler
    }
}

extension OpenWeatherAPI: OpenWeatherAPIType {
    func getWeather<T: Decodable>(
        path: EndpointPath,
        city: String,
        decoder: JSONDecoder,
        as: T.Type,
        apiKey: String
    ) async throws -> T {
        let query = [
            "q": city,
            "units": "metric",
            "appid": apiKey
        ]
        
        let data = try await handler.performRequest(path: path.rawValue, query: query)
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            throw WeatherAppError.DecodeError.cannotDecodeData
        }
    }
}
