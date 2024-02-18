@testable import WeatherAppProMax

final class ForecastRepositoryMock: ForecastRepositoryType {
    let mockForecast = [WeatherModel.mock]
    
    func getForecast(for city: String) async throws -> [WeatherModel] {
        mockForecast
    }
}
