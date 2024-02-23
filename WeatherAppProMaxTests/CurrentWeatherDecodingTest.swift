import XCTest
@testable import WeatherAppProMax

final class CurrentWeatherDecodingTest: XCTestCase {
    private var data: Data!
    
    override func setUpWithError() throws {
        data = CurrentResponse.mockCurrentData()
    }
    
    func testCurrentDecodingFromJSON() throws {
        let decoder = JSONDecoder()
        let currentResponse = try decoder.decode(CurrentResponse.self, from: data)
        
        XCTAssertEqual(currentResponse.name, "London")
        
        XCTAssertEqual(currentResponse.dt, 1708513638)
        XCTAssertEqual(currentResponse.main.temp, 9.6)
        XCTAssertEqual(currentResponse.main.feels_like, 6.51)
        XCTAssertEqual(currentResponse.main.temp_min, 8.86)
        XCTAssertEqual(currentResponse.main.temp_max, 10.44)
    }
    
    func testMakeCurrent() throws {
        let decoder = JSONDecoder()
        let currentResponse = try decoder.decode(CurrentResponse.self, from: data)
        
        let model = WeatherModel.makeCurrent(from: currentResponse)
        
        XCTAssertEqual(model.cityName, "London")
        
        XCTAssertEqual(model.date, Date(timeIntervalSince1970: TimeInterval(1708513638 - TimeZone.current.secondsFromGMT())))
        XCTAssertEqual(model.temperature, 9.6)
        XCTAssertEqual(model.feelsLike, 6.51)
        XCTAssertEqual(model.minTemperature, 8.86)
        XCTAssertEqual(model.maxTemperature, 10.44)
    }
    
    func testCurrentDecodingFromJSONBadResponseModel() throws {
        let decoder = JSONDecoder()
        let currentResponse = try? decoder.decode(ForecastResponse.self, from: data)
        
        XCTAssertNil(currentResponse)
    }
}
