@testable import WeatherAppProMax

final class ForecastRepositoryMock: ForecastRepositoryType {
    let mockForecast = WeatherModel.makeMockForecast()
    
    func getForecast(for city: String) async throws -> [WeatherModel] {
        mockForecast
    }
}
