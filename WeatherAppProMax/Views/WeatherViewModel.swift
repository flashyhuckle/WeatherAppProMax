import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    private var repository: ForecastRepositoryType
    private var weather: Weather
    @Published var currentWeather: WeatherModel
    @Published var hourForecast: [HourForecastModel] = []
    @Published var dayForecast: [DayForecastModel] = []
    
    @Published var isForecastLoading: Bool = false
    
    
    init(
        repository: ForecastRepositoryType = ForecastRepository(),
        weather: Weather
    ) {
        self.repository = repository
        self.weather = weather
        self.currentWeather = weather.currentWeather
        loadData()
    }
    
    private func loadData() {
        hourForecast = weather.hourForecastWeather
        dayForecast = weather.dayForecastWeather
        
        isForecastLoading = false
    }
    
    func refreshForecast() async {
        //checking if forecast has freshness date
        guard let forecastRefreshDate = weather.forecastRefreshDate else {
            print("forecast for \(weather.cityName) needs to be refreshed")
            //if it doesn't, we need to fetch forecast
            await fetchForecast()
            return
        }
        
        //if we are here, forecast does have freshness date, but we check how fresh is it
        if (forecastRefreshDate + TimeInterval(600)) < Date.now {
            print("forecast for \(weather.cityName) needs to be refreshed")
            //not fresh enough - fetch new one
            await fetchForecast()
        } else {
            //its fresh, no action required
            print("forecast is less than 10 minutes old")
        }
    }
    
    func forceRefresh() async {
        //pull to refresh method - no matter how fresh the forecast is, force fetch new one
        await fetchForecast()
        print("forced a refresh for \(weather.cityName)")
    }
    
    private func fetchForecast() async {
        isForecastLoading = true
        do {
            //fetching forecast
            print("fetching new forecast for \(weather.cityName)")
            let forecast = try await repository.getForecast(for: weather.cityName)
            print("fetched new forecast for \(forecast[0].cityName)")
            //editing model data with fresh entries
            weather.hourForecastWeather = HourForecastModel.makeHourForecast(from: forecast)
            weather.dayForecastWeather = DayForecastModel.makeDayForecast(from: forecast)
            weather.forecastRefreshDate = Date.now
            //refreshing @Published values
            loadData()
        } catch {
            print(error)
        }
    }
}
