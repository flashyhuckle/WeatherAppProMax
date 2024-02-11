@testable import WeatherAppProMax

final class ForecastRepositoryMock: ForecastRepositoryType {
    var mockForecast = [WeatherModel.example]
    
    func getForecast(for city: String) async throws -> [WeatherAppProMax.WeatherModel] {
        mockForecast
    }
}
