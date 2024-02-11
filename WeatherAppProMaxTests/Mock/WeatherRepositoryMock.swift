@testable import WeatherAppProMax

final class WeatherRepositoryMock: WeatherRepositoryType {
    var mockWeather = WeatherModel.example
    
    func getWeather(for city: String) async throws -> WeatherAppProMax.WeatherModel {
        mockWeather
    }
}
