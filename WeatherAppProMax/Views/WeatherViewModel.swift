import Foundation
import SwiftData
import SwiftUI

class WeatherViewModel: ObservableObject {
    private var repository = WeatherRepository()
    var context: ModelContext
    @Published var weathers: [Weather] = []
    @Published var currentWeather = WeatherModel.example
    @Published var forecast: [WeatherModel] = []
    
    func refreshWeather(for city: String) {
        if let weatherForCity = weathers.first(where: {$0.cityName == city}) {
            currentWeather = weatherForCity.currentWeather
            forecast = weatherForCity.forecastWeather
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
            let weather = try await repository.getForecast(for: city)
            forecast = weather
            print("fetched new forecast for \(weather[0].cityName)")
            if let cityWeather = weathers.first(where: {$0.cityName == city}) {
                cityWeather.forecastWeather = weather
                cityWeather.forecastRefreshDate = Date.now
            }
            loadData()
        }
    }
    
    func saveModel(model: Weather) {
        context.insert(model)
    }
    
    init(context: ModelContext) {
        self.context = context
        loadData()
    }
    
    private func loadData() {
        do {
            let descriptor = FetchDescriptor<Weather>(sortBy: [SortDescriptor(\.cityName)])
            weathers = try context.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
        print(weathers.map{$0.cityName})
    }
    
//    private func add(city: WeatherModel) {
//        do {
//            let cityToDelete = city.cityName
//            try context.delete(model: WeatherModel.self, where: #Predicate { $0.cityName == cityToDelete})
//        } catch {
//            print("clear")
//        }
//        context.insert(city)
//        loadData()
//    }

}
