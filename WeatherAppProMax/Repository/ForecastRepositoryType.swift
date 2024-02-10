protocol ForecastRepositoryType {
    func getForecast(for city: String) async throws -> [WeatherModel]
}
