import XCTest
@testable import WeatherAppProMax

final class ForecastDecodingTest: XCTestCase {
    private var data: Data!
    
    override func setUpWithError() throws {
        guard let url = Bundle(for: type(of: self)).url(forResource: "ForecastTestData", withExtension: "json") else {
            throw NSError(domain: "Test Forecast decoding", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found"])
        }
        
        data = try Data(contentsOf: url)
    }
    
    func testForecastDecodingFromJSON() throws {
        let decoder = JSONDecoder()
        let forecastResponse = try decoder.decode(ForecastResponse.self, from: data)
        
        XCTAssertEqual(forecastResponse.list.count, 5)
        XCTAssertEqual(forecastResponse.city.name, "London")
        
        let firstItem = forecastResponse.list[0]
        XCTAssertEqual(firstItem.dt, 1707674400)
        XCTAssertEqual(firstItem.main.temp, 282.18)
        XCTAssertEqual(firstItem.main.feels_like, 280.11)
        XCTAssertEqual(firstItem.main.temp_min, 281.73)
        XCTAssertEqual(firstItem.main.temp_max, 282.18)
    }
    
    func testForecastDecodingFromJSONBadResponseModel() throws {
        let decoder = JSONDecoder()
        let forecastResponse = try? decoder.decode(CurrentResponse.self, from: data)
        
        XCTAssertNil(forecastResponse)
    }
    
    
}
