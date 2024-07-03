import WeatherAppProMax

import Foundation

final public class OpenWeatherAPIMock: OpenWeatherAPIType {
    var mockCurrentResponse = CurrentResponse.mockCurrentResponse()
    var mockForecastResponse = ForecastResponse.mockForecastResponse()
    
    public func getWeather<T>(path: EndpointPath, city: String, decoder: JSONDecoder, as: T.Type, apiKey: String) async throws -> T where T : Decodable {
        switch path {
        case .forecast:
            if let response = mockForecastResponse as? T {
                return response
            } else {
                throw WeatherAppError.DecodeError.cannotDecodeData
            }
        case .weather:
            if let response = mockCurrentResponse as? T {
                return response
            } else {
                throw WeatherAppError.DecodeError.cannotDecodeData
            }
        }
    }
}
