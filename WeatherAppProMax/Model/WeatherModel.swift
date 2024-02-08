import Foundation
import SwiftData

enum WeatherType {
    case hot
    case warm
    case mild
    case cold
    case freezing
}

@Model
class Weather: Equatable {
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
        currentWeather: WeatherModel = WeatherModel.example,
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

struct WeatherModel: Codable, Hashable {
    
    let cityName: String
    let country: String
    let date: Date
    let temperature: Float
    let maxTemperature: Float
    let minTemperature: Float
    let icon: String
    let descriptionString: String
    let sunrise: Int
    let sunset: Int
    let pressure: Int
    let windSpeed: Float
    let timezone: Int
    let humidity: Int
    let visibility: Int
    let feelsLike: Float
    
    var sunriseString: String {
        Date(timeIntervalSince1970: TimeInterval(sunrise + timezone - TimeZone.current.secondsFromGMT())).formatted(date: .omitted, time: .shortened)
    }
    
    var sunsetString: String {
        Date(timeIntervalSince1970: TimeInterval(sunset + timezone - TimeZone.current.secondsFromGMT())).formatted(date: .omitted, time: .shortened)
    }
    
    var dateString: String {
        date.formatted(Date.FormatStyle().weekday(.wide).month(.wide).day(.twoDigits))
    }
    
    var shortDateString: String {
        date.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits))
    }
    
    var hourString: String {
        date.formatted(Date.FormatStyle().hour().minute())
    }
    
    var locationString: String {
        cityName + ", " + (country)
    }
    
    var temperatureString: String {
        getTemperatureString(from: temperature)
    }
    
    var maxtemperatureString: String {
        getTemperatureString(from: maxTemperature)
    }
    
    var mintemperatureString: String {
        getTemperatureString(from: minTemperature)
    }
    
    var feelsLikeString: String {
        getTemperatureString(from: feelsLike)
    }
    
    private func getTemperatureString(from temperature: Float) -> String {
        let temp = String(format: "%.0f", temperature) + "°"
        if temp == "-0°" {
            return "0°"
        } else {
            return temp
        }
    }
    
    var pressureString: String {
        return String(pressure) + "hPa"
    }
    
    var windSpeedString: String {
        String(format: "%.0f", windSpeed) + "km/h"
    }
    
    var weatherType: WeatherType {
        switch temperature {
        case 30... :
            return .hot
        case 20...30 :
            return .warm
        case 10...20 :
            return .mild
        case 0...10 :
            return .cold
        case ...0 :
            return .freezing
        default:
            return .mild
        }
    }
    
    var systemIcon: String {
        switch icon {
        case "01d":
            return "sun.max"
        case "01n":
            return "moon"
        case "02d":
            return "cloud.sun"
        case "02n":
            return "cloud.moon"
        case "03d", "03n":
            return "cloud"
        case "04d", "04n":
            return "cloud"
        case "09d", "09n":
            return "cloud.drizzle"
        case "10d", "10n":
            return "cloud.rain"
        case "11d", "11n":
            return "cloud.bolt.rain"
        case "13d", "13n":
            return "cloud.snow"
        case "50d", "50n":
            return "cloud.fog"
        default:
            return "sun.max.trianglebadge.exclamationmark"
        }
    }
    
    init(cityName: String,
         country: String,
         date: Date,
         temperature: Float,
         maxTemperature: Float,
         minTemperature: Float,
         icon: String,
         descriptionString: String,
         sunrise: Int,
         sunset: Int,
         pressure: Int,
         windSpeed: Float,
         timezone: Int,
         humidity: Int,
         visibility: Int,
         feelsLike: Float
    ) {
        self.cityName = cityName
        self.country = country
        self.date = date
        self.temperature = temperature
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        self.icon = icon
        self.descriptionString = descriptionString
        self.sunrise = sunrise
        self.sunset = sunset
        self.pressure = pressure
        self.windSpeed = windSpeed
        self.timezone = timezone
        self.humidity = humidity
        self.visibility = visibility
        self.feelsLike = feelsLike
    }
    
    static let example = WeatherModel(
        cityName: "London",
        country: "UK",
        date: Date(),
        temperature: 0,
        maxTemperature: 0,
        minTemperature: 0,
        icon: "cloud",
        descriptionString: "",
        sunrise: 0,
        sunset: 0,
        pressure: 0,
        windSpeed: 0,
        timezone: 0,
        humidity: 0,
        visibility: 0,
        feelsLike: 0
    )
}

extension WeatherModel {
    static func makeForecast(
        from response: ForecastResponse
    ) -> [WeatherModel] {
        response.list.map { weather in
            WeatherModel(
                cityName: response.city.name,
                country: response.city.country,
                date: Date(timeIntervalSince1970: TimeInterval(weather.dt)),
                temperature: weather.main.temp,
                maxTemperature: weather.main.temp_max,
                minTemperature: weather.main.temp_min,
                icon: weather.weather[0].icon,
                descriptionString: weather.weather[0].description,
                sunrise: response.city.sunrise,
                sunset: response.city.sunset,
                pressure: weather.main.pressure,
                windSpeed: weather.wind.speed,
                timezone: response.city.timezone,
                humidity: weather.main.humidity,
                visibility: weather.visibility,
                feelsLike: weather.main.feels_like
            )
        }
    }
    
    static func makeCurrent(
        from response: CurrentResponse
    ) -> WeatherModel {
        WeatherModel(
            cityName: response.name,
            country: response.sys.country,
            date: Date(timeIntervalSince1970: TimeInterval(response.dt)),
            temperature: response.main.temp,
            maxTemperature: response.main.temp_max,
            minTemperature: response.main.temp_min,
            icon: response.weather[0].icon,
            descriptionString: response.weather[0].description,
            sunrise: response.sys.sunrise,
            sunset: response.sys.sunset,
            pressure: response.main.pressure,
            windSpeed: response.wind.speed,
            timezone: response.timezone,
            humidity: response.main.humidity,
            visibility: response.visibility,
            feelsLike: response.main.feels_like
        )
    }
}

struct HourForecastModel: Codable, Hashable {
    let cityName: String
    let date: Date
    let temperature: Float
    let systemIcon: String
    
    var temperatureString: String {
        getTemperatureString(from: temperature)
    }
    
    var hourString: String {
        date.formatted(Date.FormatStyle().hour().minute())
    }
    
    private func getTemperatureString(from temperature: Float) -> String {
        let temp = String(format: "%.0f", temperature) + "°"
        if temp == "-0°" {
            return "0°"
        } else {
            return temp
        }
    }
}

struct DayForecastModel: Codable, Hashable {
    let cityName: String
    let date: Date
    let maxTemperature: Float
    let minTemperature: Float
    let systemIcon: String
    
    var maxtemperatureString: String {
        getTemperatureString(from: maxTemperature)
    }
    
    var mintemperatureString: String {
        getTemperatureString(from: minTemperature)
    }
    
    private func getTemperatureString(from temperature: Float) -> String {
        let temp = String(format: "%.0f", temperature) + "°"
        if temp == "-0°" {
            return "0°"
        } else {
            return temp
        }
    }
}
