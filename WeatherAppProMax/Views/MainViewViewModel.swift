import Foundation
import SwiftData

final class MainViewViewModel: ObservableObject {
    private let repository: WeatherRepositoryType
    let storage: SwiftDataStorage
    @Published var weathers = [Weather]()
    
    init(
        storage: SwiftDataStorage = SwiftDataStorage(model: Weather.self),
        repository: WeatherRepositoryType = WeatherRepository()
    ) {
        self.storage = storage
        self.repository = repository
        loadData()
    }
    
    func loadData() {
        weathers = storage.loadObjects()
        print(weathers.map{$0.cityName})
    }
    
    func refreshWeather(for city: String) {
        if let weatherForCity = weathers.first(where: {$0.cityName == city}) {
            print("loaded weather for \(weatherForCity.cityName) from memory")
            
            if (weatherForCity.currentRefreshDate + TimeInterval(600)) < Date.now {
                print("...but weather for \(weatherForCity.cityName) needs to be refreshed")
                fetchWeather(for: city)
            } else {
                print("...and its less than 10 minutes old")
            }
        } else {
            fetchWeather(for: city)
        }
    }
    
    func forceRefreshAllWeathers() {
        for weather in weathers {
            fetchWeather(for: weather.cityName)
        }
    }
    
    private func fetchWeather(for city: String) {
        print("fetching new weather for \(city) at \(Date.now)")
        Task { @MainActor in
            let currentWeather = try await repository.getWeather(for: city)
            if let weatherForCity = weathers.first(where: {$0.cityName == city}) {
                weatherForCity.currentWeather = currentWeather
                weatherForCity.currentRefreshDate = Date.now
            } else {
                let weather = Weather(
                    cityName: currentWeather.cityName,
                    country: currentWeather.country,
                    timezone: currentWeather.timezone,
                    currentWeather: currentWeather
                )
                storage.saveObject(weather)
            }
            loadData()
        }
    }
    
    func remove(city: String) {
        storage.removeObject(for: city)
        loadData()
    }
    
    func clearData() {
        storage.removeAllData()
        loadData()
    }
}
