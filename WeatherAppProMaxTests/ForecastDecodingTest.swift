import XCTest
@testable import WeatherAppProMax

final class ForecastDecodingTest: XCTestCase {
    private var data: Data!
    
    override func setUpWithError() throws {
        data = ForecastResponse.mockForecastData()
    }
    
    func testForecastDecodingFromJSON() throws {
        let decoder = JSONDecoder()
        let forecastResponse = try decoder.decode(ForecastResponse.self, from: data)
        
        XCTAssertEqual(forecastResponse.list.count, 40)
        XCTAssertEqual(forecastResponse.city.name, "London")
        
        let firstItem = forecastResponse.list[0]
        XCTAssertEqual(firstItem.dt, 1708516800)
        XCTAssertEqual(firstItem.main.temp, 9.61)
        XCTAssertEqual(firstItem.main.feels_like, 6.02)
        XCTAssertEqual(firstItem.main.temp_min, 9.61)
        XCTAssertEqual(firstItem.main.temp_max, 9.74)
    }
    
    func testMakeForecast() throws {
        let decoder = JSONDecoder()
        let forecastResponse = try decoder.decode(ForecastResponse.self, from: data)
        
        let model = WeatherModel.makeForecast(from: forecastResponse)
        
        XCTAssertEqual(model.count, 40)
        
        let first = model[0]
        
        XCTAssertEqual(first.cityName, "London")
        XCTAssertEqual(first.date, Date(timeIntervalSince1970: TimeInterval(1708516800 - TimeZone.current.secondsFromGMT())))
        XCTAssertEqual(first.temperature, 9.61)
        XCTAssertEqual(first.feelsLike, 6.02)
        XCTAssertEqual(first.minTemperature, 9.61)
        XCTAssertEqual(first.maxTemperature, 9.74)
    }
    
    func testMakeHourForecast() throws {
        let decoder = JSONDecoder()
        let forecastResponse = try decoder.decode(ForecastResponse.self, from: data)
        
        let model = WeatherModel.makeForecast(from: forecastResponse)
        
        let hourForecast = HourForecastModel.makeHourForecast(from: model)
        
        XCTAssertEqual(hourForecast.count, 9)
        
        let first = hourForecast[0]
        
        XCTAssertEqual(first.cityName, "London")
        XCTAssertEqual(first.date, Date(timeIntervalSince1970: TimeInterval(1708516800 - TimeZone.current.secondsFromGMT())))
        XCTAssertEqual(first.temperature, 9.61)
    }
    
    func testMakeDayForecast() throws {
        let decoder = JSONDecoder()
        let forecastResponse = try decoder.decode(ForecastResponse.self, from: data)
        
        let model = WeatherModel.makeForecast(from: forecastResponse)
        
        let dayForecast = DayForecastModel.makeDayForecast(from: model)
        
        XCTAssertEqual(dayForecast.count, 6)
        
        let first = dayForecast[0]
        
        XCTAssertEqual(first.cityName, "London")
        XCTAssertEqual(first.date, Date(timeIntervalSince1970: TimeInterval(1708473600 - TimeZone.current.secondsFromGMT())))
        XCTAssertEqual(first.maxTemperature, 10.81)
        XCTAssertEqual(first.minTemperature, 9.61)
    }
    
    func testForecastDecodingFromJSONBadResponseModel() throws {
        let decoder = JSONDecoder()
        let forecastResponse = try? decoder.decode(CurrentResponse.self, from: data)
        
        XCTAssertNil(forecastResponse)
    }
}
