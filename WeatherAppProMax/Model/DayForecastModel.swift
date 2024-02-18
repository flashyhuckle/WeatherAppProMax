import Foundation

struct DayForecastModel: Codable, Hashable {
    let cityName: String
    let date: Date
    let maxTemperature: Float
    let minTemperature: Float
    let systemIcon: String
    
    var maxtemperatureString: String {
        maxTemperature.toString()
    }
    
    var mintemperatureString: String {
        minTemperature.toString()
    }
    
    var dayString: String {
        date.dayString()
    }
}

extension DayForecastModel {
    static func makeDayForecast(from forecast: [WeatherModel]) -> [DayForecastModel] {
        let groupedByDay = Dictionary(grouping: forecast, by: { Calendar.current.startOfDay(for: $0.date) })
        
        var dayForecast: [DayForecastModel] = groupedByDay.keys.sorted().compactMap { date in
            guard let values = groupedByDay[date],
                  let maxTempForecast = values.max(by: { $0.maxTemperature < $1.maxTemperature }),
                  let minTempForecast = values.min(by: { $0.minTemperature < $1.minTemperature }) else {
                return nil
            }
            return DayForecastModel(cityName: maxTempForecast.cityName,
                                    date: date,
                                    maxTemperature: maxTempForecast.maxTemperature,
                                    minTemperature: minTempForecast.minTemperature,
                                    systemIcon: maxTempForecast.systemIcon
            )
        }
        
        if dayForecast[0].date.formatted(Date.FormatStyle().day()) == Date.now.formatted(Date.FormatStyle().day()) {
            dayForecast.removeFirst()
        }
        
        return dayForecast
    }
}
