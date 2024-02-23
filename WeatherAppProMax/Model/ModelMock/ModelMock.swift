import Foundation

final class ModelMock {
    
}

extension ForecastResponse {
    public static func mockForecastData() -> Data {
        let bundle = Bundle(for: ModelMock.self)
        guard let path = bundle.path(forResource: "ForecastTestData", ofType: "json") else { fatalError("ForecastTestData.json not found.") }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { fatalError("ForecastTestData.json has bad data.") }
        return data
    }
    
    public static func mockForecastResponse() -> ForecastResponse {
        guard let decoded = try? JSONDecoder().decode(ForecastResponse.self, from: self.mockForecastData()) else { fatalError("ForecastTestData.json couldn't be decoded.") }
        return decoded
    }
}

extension CurrentResponse {
    public static func mockCurrentData() -> Data {
        let bundle = Bundle(for: ModelMock.self)
        guard let path = bundle.path(forResource: "CurrentWeatherTestData", ofType: "json") else { fatalError("CurrentWeatherTestData.json not found.") }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { fatalError("CurrentWeatherTestData.json has bad data.") }
        return data
    }
    
    public static func mockCurrentResponse() -> CurrentResponse {
        guard let decoded = try? JSONDecoder().decode(CurrentResponse.self, from: self.mockCurrentData()) else { fatalError("CurrentWeatherTestData.json couldn't be decoded.") }
        return decoded
    }
}

extension WeatherModel {
    public static func makeMockCurrentWeather() -> WeatherModel {
        WeatherModel.makeCurrent(from: CurrentResponse.mockCurrentResponse())
    }
    
    public static func makeMockForecast() -> [WeatherModel] {
        WeatherModel.makeForecast(from: ForecastResponse.mockForecastResponse())
    }
}

extension Weather {
    public static func makeMock() -> Weather {
        let model = WeatherModel.makeMockCurrentWeather()
        return Weather(
            cityName: model.cityName,
            country: model.country,
            timezone: model.timezone,
            currentWeather: model
        )
    }
}
