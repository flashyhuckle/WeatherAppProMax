@testable import WeatherAppProMax

final class WeatherRepositoryMock: WeatherRepositoryType {
    let mockWeather = WeatherModel.example
    
    func getWeather(for city: String) async throws -> WeatherModel {
        mockWeather
    }
}
