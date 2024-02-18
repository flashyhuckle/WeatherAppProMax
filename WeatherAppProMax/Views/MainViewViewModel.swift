import Foundation
import SwiftData

@MainActor
final class MainViewViewModel: ObservableObject {
    private let repository: WeatherRepositoryType
    let storage: any StorageType<Weather>
    @Published var weathers = [Weather]()
    
    @Published var isEditEnabled: Bool = false
    @Published var addAlertShowing: Bool = false
    
    init(
        storage: any StorageType<Weather> = SwiftDataStorage(model: Weather.self),
        repository: WeatherRepositoryType = WeatherRepository()
    ) {
        self.storage = storage
        self.repository = repository
        //loading data at init to get all stored models into weathers array
        loadData()
    }
    
    private func loadData() {
        //loading all weather models from our storage
        weathers = storage.loadObjects()
        print(weathers.map{$0.cityName})
    }
    
    func toolbarAddButtonPressed() {
        addAlertShowing = true
        isEditEnabled = false
    }
    
    func toolbarEdutButtonPressed() {
        isEditEnabled.toggle()
    }
    
    func addNew(city: String) async {
        await fetchWeather(for: city)
    }
    
    func onAppear() async {
        for weather in weathers {
            await refreshIfOld(for: weather)
        }
    }
    
    func refresh() async {
        //pull to refresh method - no matter how fresh the weather is, force fetch new ones
        for weather in weathers {
            await fetchWeather(for: weather.cityName)
        }
    }
    
    func remove(city: String){
        //remove city from storage
        storage.removeObject(for: city)
        //and call loadData to refresh weathers array
        loadData()
        
        if weathers.isEmpty {
            isEditEnabled = false
        }
    }
    
    private func refreshIfOld(for weather: Weather) async {
        print("loaded weather for \(weather.cityName) from memory")
        
        //checking "freshness" of weather
        if (weather.currentRefreshDate + TimeInterval(600)) < Date.now {
            print("...but weather for \(weather.cityName) needs to be refreshed")
            //weather is old, therefore we are fetching new one
            await fetchWeather(for: weather.cityName)
        } else {
            //it is relatively fresh, so we dont fetch new one
            print("...and its less than 10 minutes old")
        }
    }
    
    private func fetchWeather(for city: String) async {
        print("fetching new weather for \(city) at \(Date.now)")
        do {
            //fething weather for cityName
            let currentWeather = try await repository.getWeather(for: city)
            //checking if we have a model for this city
            if let weatherForCity = weathers.first(where: {$0.cityName == currentWeather.cityName}) {
                //if we have a model, refresh its data
                weatherForCity.currentWeather = currentWeather
                weatherForCity.currentRefreshDate = Date.now
            } else {
                //if we dont have a model, we create a new one
                let weather = Weather(
                    cityName: currentWeather.cityName,
                    country: currentWeather.country,
                    timezone: currentWeather.timezone,
                    currentWeather: currentWeather
                )
                //we save object in our storage
                storage.saveObject(weather)
                //and call loadData to refresh weathers array
                loadData()
            }
        } catch {
            //handle errors
        }
    }
}
