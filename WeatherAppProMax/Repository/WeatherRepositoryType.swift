protocol WeatherRepositoryType {
    func getWeather(for city: String) async throws -> WeatherModel
}
