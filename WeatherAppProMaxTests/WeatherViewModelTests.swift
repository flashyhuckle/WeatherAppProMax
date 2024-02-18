import XCTest
@testable import WeatherAppProMax

@MainActor
final class WeatherViewModelTests: XCTestCase {
    private let repository = ForecastRepositoryMock()
  
    func testLoadData() {
        let weather = Weather.makeMock()
        let vm = WeatherViewModel(repository: repository, weather: weather)
        
        XCTAssertEqual(weather.currentWeather, vm.currentWeather)
        XCTAssertEqual(weather.hourForecastWeather, vm.hourForecast)
        XCTAssertEqual(weather.dayForecastWeather, vm.dayForecast)
        XCTAssertTrue(vm.hourForecast.isEmpty)
        XCTAssertTrue(vm.dayForecast.isEmpty)
    }
    
    func testRefreshForecastWithNoDate() async {
        let weather = Weather.makeMock()
        let vm = WeatherViewModel(repository: repository, weather: weather)
        
        XCTAssertTrue(vm.hourForecast.isEmpty)
        XCTAssertTrue(vm.dayForecast.isEmpty)
        
        
        await vm.refreshForecast()
        
        XCTAssertEqual(weather.currentWeather, vm.currentWeather)
        
        XCTAssertFalse(vm.hourForecast.isEmpty)
        XCTAssertFalse(vm.dayForecast.isEmpty)
        
        XCTAssertEqual(weather.hourForecastWeather, vm.hourForecast)
        XCTAssertEqual(weather.dayForecastWeather, vm.dayForecast)
    }
    
    func testRefreshForecastWithFreshDate() async {
        let weather = Weather.makeMock()
        weather.forecastRefreshDate = .now
        let vm = WeatherViewModel(repository: repository, weather: weather)
        
        XCTAssertTrue(vm.hourForecast.isEmpty)
        XCTAssertTrue(vm.dayForecast.isEmpty)
        
        
        await vm.refreshForecast()
        
        XCTAssertEqual(weather.currentWeather, vm.currentWeather)
        
        XCTAssertTrue(vm.hourForecast.isEmpty)
        XCTAssertTrue(vm.dayForecast.isEmpty)
        
        XCTAssertEqual(weather.hourForecastWeather, vm.hourForecast)
        XCTAssertEqual(weather.dayForecastWeather, vm.dayForecast)
    }
    
    func testRefreshForecastWithOldDate() async {
        let weather = Weather.makeMock()
        weather.forecastRefreshDate = .now - TimeInterval(601)
        let vm = WeatherViewModel(repository: repository, weather: weather)
        
        XCTAssertTrue(vm.hourForecast.isEmpty)
        XCTAssertTrue(vm.dayForecast.isEmpty)
        
        
        await vm.refreshForecast()
        
        XCTAssertEqual(weather.currentWeather, vm.currentWeather)
        
        XCTAssertFalse(vm.hourForecast.isEmpty)
        XCTAssertFalse(vm.dayForecast.isEmpty)
        
        XCTAssertEqual(weather.hourForecastWeather, vm.hourForecast)
        XCTAssertEqual(weather.dayForecastWeather, vm.dayForecast)
    }
    
    func testForceRefreshForecastWithFreshDate() async {
        let weather = Weather.makeMock()
        weather.forecastRefreshDate = .now
        
        let vm = WeatherViewModel(repository: repository, weather: weather)
        
        XCTAssertTrue(vm.hourForecast.isEmpty)
        XCTAssertTrue(vm.dayForecast.isEmpty)
        
        
        await vm.forceRefresh()
        
        XCTAssertEqual(weather.currentWeather, vm.currentWeather)
        
        XCTAssertFalse(vm.hourForecast.isEmpty)
        XCTAssertFalse(vm.dayForecast.isEmpty)
        
        XCTAssertEqual(weather.hourForecastWeather, vm.hourForecast)
        XCTAssertEqual(weather.dayForecastWeather, vm.dayForecast)
    }
    
    
}

extension Weather {
    static func makeMock() -> Weather {
        Weather(cityName: Weather.example.cityName, country: Weather.example.country, timezone: Weather.example.timezone)
    }
}
