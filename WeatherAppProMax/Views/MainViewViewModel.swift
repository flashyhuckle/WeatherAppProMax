import Foundation
import SwiftData

class MainViewViewModel: ObservableObject {
    private var repository = WeatherRepository()
    var context: ModelContext
    @Published var weathers = [Weather]()
    
    init(context: ModelContext) {
        self.context = context
        loadData()
    }
    
     func loadData() {
        do {
            let descriptor = FetchDescriptor<Weather>(sortBy: [SortDescriptor(\.cityName)])
            weathers = try context.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
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
    
    func addCity(_ city: String) {
        fetchWeather(for: city)
    }
    
    private func fetchWeather(for city: String) {
        print("fetching new weather for \(city) at \(Date.now)")
        Task { @MainActor in
            let currentWeather = try await repository.getCurrentWeather(for: city)
            if let weatherForCity = weathers.first(where: {$0.cityName == city}) {
                weatherForCity.currentWeather = currentWeather[0]
                weatherForCity.currentRefreshDate = Date.now
//                loadData()
            } else {
                let weather = Weather(
                    cityName: currentWeather[0].cityName,
                    country: currentWeather[0].country,
                    timezone: currentWeather[0].timezone,
                    currentWeather: currentWeather[0]
                )
                context.insert(weather)
//                loadData()
            }
            loadData()
        }
    }
    
    func remove(city: String) {
        do {
            try context.delete(model: Weather.self, where: #Predicate { $0.cityName == city })
            print("deleted \(city)")
        } catch {
            print("clear")
        }
        loadData()
    }
    
    func clearData() {
        try? context.delete(model: Weather.self)
        loadData()
    }
}
