@testable import WeatherAppProMax

final class WeatherRepositoryMock: WeatherRepositoryType {
    let mockWeather = WeatherModel.makeMockCurrentWeather()
    
    func getWeather(for city: String) async throws -> WeatherModel {
        mockWeather
    }
}
