import Foundation
import SwiftData

@Model
public class Weather: Equatable {
    @Attribute(.unique) let cityName: String
    let country: String
    let timezone: Int
    
    var locationString: String {
        cityName + ", " + (country)
    }
    
    var currentRefreshDate: Date
    var forecastRefreshDate: Date?
    
    var currentWeather: WeatherModel
    var hourForecastWeather: [HourForecastModel]
    var dayForecastWeather: [DayForecastModel]
    
    init(
        cityName: String,
        country: String,
        timezone: Int,
        currentWeather: WeatherModel,
        hourForecastWeather: [HourForecastModel] = [],
        dayForecastWeather: [DayForecastModel] = []
    ) {
        self.cityName = cityName
        self.country = country
        self.timezone = timezone
        self.currentRefreshDate = Date.now
        self.currentWeather = currentWeather
        self.hourForecastWeather = hourForecastWeather
        self.dayForecastWeather = dayForecastWeather
    }
}

extension Weather {
    static func makeWeather(from model: WeatherModel) -> Weather {
        Weather(
            cityName: model.cityName,
            country: model.country,
            timezone: model.timezone,
            currentWeather: model
        )
    }
}
