import Foundation
import SwiftData
import SwiftUI

class WeatherViewModel: ObservableObject {
    private var repository: ForecastRepositoryType
    private let storage: any StorageType<Weather>
    private var weathers: [Weather] = []
    @Published var currentWeather = WeatherModel.example
    @Published var hourForecast: [HourForecastModel] = []
    @Published var dayForecast: [DayForecastModel] = []
    
    init(
        storage: any StorageType<Weather> = SwiftDataStorage(model: Weather.self),
        repository: ForecastRepositoryType = ForecastRepository()
    ) {
        self.storage = storage
        self.repository = repository
        loadData()
    }
    
    func refreshForecast(for city: String) {
        if let weatherForCity = weathers.first(where: {$0.cityName == city}) {
            currentWeather = weatherForCity.currentWeather
            hourForecast = weatherForCity.hourForecastWeather
            dayForecast = weatherForCity.dayForecastWeather
            print("loaded forecast for \(weatherForCity.cityName) from memory")
            
            guard let forecastRefreshDate = weatherForCity.forecastRefreshDate else {
                print("...but forecast for \(weatherForCity.cityName) needs to be refreshed")
                fetchWeather(for: city)
                return
            }
            
            if (forecastRefreshDate + TimeInterval(600)) < Date.now {
                print("...but forecast for \(weatherForCity.cityName) needs to be refreshed")
                fetchWeather(for: city)
            } else {
                print("...and its less than 10 minutes old")
            }
        } else {
            fetchWeather(for: city)
        }
    }
    
    func forceRefresh(for city: String) {
        fetchWeather(for: city)
        print("forced a refresh for \(city)")
    }
    
    private func fetchWeather(for city: String) {
        Task { @MainActor in
            let forecast = try await repository.getForecast(for: city)
            print("fetched new forecast for \(forecast[0].cityName)")
            if let cityWeather = weathers.first(where: {$0.cityName == city}) {
                cityWeather.hourForecastWeather = makeHourForecast(from: forecast)
                cityWeather.dayForecastWeather = makeDayForecast(from: forecast)
                cityWeather.forecastRefreshDate = Date.now
            }
            loadData()
        }
    }
    
    private func makeHourForecast(from forecast: [WeatherModel]) -> [HourForecastModel] {
        var tempHourForecast = [HourForecastModel]()
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
        hourForecast = tempHourForecast
        return tempHourForecast
    }
    
    private func makeDayForecast(from forecast: [WeatherModel]) -> [DayForecastModel] {
        let groupedByDay = Dictionary(grouping: forecast) {
            let startOfDay = Calendar.current.startOfDay(for: $0.date)
            return startOfDay
        }
        
        dayForecast = groupedByDay.keys.sorted().compactMap { date in
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
    
    private func loadData() {
        weathers = storage.loadObjects()
        
        print(weathers.map{$0.cityName})
    }
}
