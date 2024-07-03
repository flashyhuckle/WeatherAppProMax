import XCTest

@testable import WeatherAppProMax

final class WeatherRepositoryTests: XCTestCase {
    private var repository: WeatherRepositoryType!
    
    private let api = OpenWeatherAPIMock()
    private let monitor = PathMonitorMock()
    
    override func setUpWithError() throws {
        repository = WeatherRepository(monitor: monitor, api: api)
    }
    
    func testWeatherFromAPIWhenNetworkOn() async throws {
        let weather = try await repository.getWeather(for: "London")
        XCTAssertEqual(weather.cityName, "London")
    }
    
    func testWeatherFromAPIWhenNetworkOff() async throws {
        monitor.isNetworkOn = false
        do {
            _ = try await repository.getWeather(for: "London")
        } catch {
            XCTAssertTrue(error is WeatherAppError.NetworkError)
            XCTAssertEqual(error as? WeatherAppError.NetworkError, WeatherAppError.NetworkError.noConnection)
        }
    }
}
