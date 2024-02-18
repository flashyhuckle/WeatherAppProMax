import XCTest
@testable import WeatherAppProMax

final class CurrentWeatherDecodingTest: XCTestCase {
    private var data: Data!
    
    override func setUpWithError() throws {
        guard let url = Bundle(for: type(of: self)).url(forResource: "CurrentWeatherTestData", withExtension: "json") else {
            throw NSError(domain: "Test Forecast decoding", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found"])
        }
        
        data = try Data(contentsOf: url)
    }
    
    func testCurrentDecodingFromJSON() throws {
        let decoder = JSONDecoder()
        let currentResponse = try decoder.decode(CurrentResponse.self, from: data)
        
        XCTAssertEqual(currentResponse.name, "London")
        
        XCTAssertEqual(currentResponse.dt, 1707672453)
        XCTAssertEqual(currentResponse.main.temp, 282.47)
        XCTAssertEqual(currentResponse.main.feels_like, 280.79)
        XCTAssertEqual(currentResponse.main.temp_min, 280.64)
        XCTAssertEqual(currentResponse.main.temp_max, 283.35)
    }
    
    func testCurrentDecodingFromJSONBadResponseModel() throws {
        let decoder = JSONDecoder()
        let currentResponse = try? decoder.decode(ForecastResponse.self, from: data)
        
        XCTAssertNil(currentResponse)
    }
}
