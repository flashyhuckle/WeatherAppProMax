import XCTest

@testable import OpenWeatherNetworking
@testable import WeatherAppError
@testable import WeatherAppProMax

final class ForecastRepositoryTests: XCTestCase {
    private var repository: ForecastRepositoryType!
    
    private let api = OpenWeatherAPIMock()
    private let monitor = PathMonitorMock()
    
    override func setUpWithError() throws {
        repository = ForecastRepository(monitor: monitor, api: api)
    }
    
    func testForecastFromAPIWhenNetworkOn() async throws {
        let forecast = try await repository.getForecast(for: "London")
        XCTAssertEqual(forecast[0].cityName, "London")
    }
    
    func testForecastFromAPIWhenNetworkOff() async throws {
        monitor.isNetworkOn = false
        do {
            _ = try await repository.getForecast(for: "London")
        } catch {
            XCTAssertTrue(error is WeatherAppError.NetworkError)
            XCTAssertEqual(error as? WeatherAppError.NetworkError, WeatherAppError.NetworkError.noConnection)
        }
    }
}
