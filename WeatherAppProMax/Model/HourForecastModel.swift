import Foundation

struct HourForecastModel: Codable, Hashable {
    let cityName: String
    let date: Date
    let temperature: Float
    let systemIcon: String
    
    var temperatureString: String {
        temperature.toString()
    }
    
    var hourString: String {
        date.hourString()
    }
}

extension HourForecastModel {
    static func makeHourForecast(from forecast: [WeatherModel]) -> [HourForecastModel] {
        var tempHourForecast = [HourForecastModel]()
        //we just want next 9 entries by design - if somehow our forecast has less, we create less
        for i in 0..<(min(9, forecast.count)) {
            tempHourForecast.append(
                HourForecastModel(
                    cityName: forecast[i].cityName,
                    date: forecast[i].date,
                    temperature: forecast[i].temperature,
                    systemIcon: forecast[i].systemIcon
                )
            )
        }
        return tempHourForecast
    }
}
