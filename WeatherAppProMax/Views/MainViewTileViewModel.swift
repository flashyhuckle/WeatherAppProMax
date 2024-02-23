import Foundation

final class MainViewTileViewModel {
    let weather: Weather
    @Published var isWeatherLoading = false
    
    
    init(weather: Weather) {
        self.weather = weather
    }
    
    func refresh() {
        print("\(weather.cityName) refresh")
    }
    
    func onAppear() {
        print("\(weather.cityName) onappear")
    }
}
