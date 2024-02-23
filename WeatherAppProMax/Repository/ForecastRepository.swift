import Foundation
import OpenWeatherNetworking
import WeatherAppError

class ForecastRepository {
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

extension ForecastRepository: ForecastRepositoryType {
    func getForecast(for city: String) async throws -> [WeatherModel] {
        if monitor.isNetworkOn {
            let response = try await api.getWeather(path: .forecast, city: city, as: ForecastResponse.self)
            let model = WeatherModel.makeForecast(from: response)
            return model
        } else {
            throw WeatherAppError.NetworkError.noConnection
        }
    }
}
