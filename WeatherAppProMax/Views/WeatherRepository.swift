import Foundation

class WeatherRepository {
    private let monitor: PathMonitor
    private let api: OpenWeatherAPIType
    
    init(
        monitor: PathMonitor = PathMonitor(),
        api: OpenWeatherAPIType = OpenWeatherAPI()
    ) {
        self.monitor = monitor
        self.api = api
    }
}

extension WeatherRepository: WeatherRepositoryType {
    func getWeather(for city: String) async throws -> WeatherModel {
        //MARK - Add storage handling
        if monitor.isNetworkOn {
            let response = try await api.getWeather(path: .weather, city: city, as: CurrentResponse.self)
            let model = WeatherModel.makeCurrent(from: response)
            return model
        } else {
            throw WeatherAppError.NetworkError.noConnection
        }
    }
}
