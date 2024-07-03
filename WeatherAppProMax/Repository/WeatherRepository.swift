import Foundation

class WeatherRepository {
    private let monitor: PathMonitorType
    private let api: OpenWeatherAPIType
    
    init(
        monitor: PathMonitorType = PathMonitor(),
        api: OpenWeatherAPIType = OpenWeatherAPI()
    ) {
        self.monitor = monitor
        self.api = api
    }
}

extension WeatherRepository: WeatherRepositoryType {
    func getWeather(for city: String) async throws -> WeatherModel {
        if monitor.isNetworkOn {
            let response = try await api.getWeather(path: .weather, city: city, as: CurrentResponse.self)
            let model = WeatherModel.makeCurrent(from: response)
            return model
        } else {
            throw WeatherAppError.NetworkError.noConnection
        }
    }
}
