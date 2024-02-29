import XCTest
@testable import WeatherAppProMax
@testable import OpenWeatherNetworking
import WeatherAppError

final class OpenWeatherAPITests: XCTestCase {
    private var api: OpenWeatherAPIType!
    
    func testGetForecast() async throws {
        api = OpenWeatherAPI(handler: URLSessionHandlerMockForecastData())
        
        do {
            let forecast = try await api.getWeather(path: .forecast, city: "London", as: ForecastResponse.self)
            XCTAssertFalse(forecast.list.isEmpty)
            XCTAssertEqual(forecast.city.name, "London")
        } catch {
            XCTFail()
        }
    }
    
    
    
    func testGetForecastBadResponseType() async throws {
        api = OpenWeatherAPI(handler: URLSessionHandlerMockForecastData())
        
        do {
            _  = try await api.getWeather(path: .forecast, city: "London", as: CurrentResponse.self)
        } catch {
            XCTAssertTrue(error is WeatherAppError.RequestError)
            XCTAssertEqual(error as? WeatherAppError.RequestError, WeatherAppError.RequestError.badResponse)
        }
    }
    
    func testGetWeather() async throws {
        api = OpenWeatherAPI(handler: URLSessionHandlerMockCurrentData())
        
        do {
            let weather = try await api.getWeather(path: .weather, city: "London", as: CurrentResponse.self)
            XCTAssertEqual(weather.name, "London")
        } catch {
            XCTFail()
        }
    }
    
    func testGetWeatherBadResponseType() async throws {
        api = OpenWeatherAPI(handler: URLSessionHandlerMockCurrentData())
        
        do {
            _  = try await api.getWeather(path: .weather, city: "London", as: ForecastResponse.self)
        } catch {
            XCTAssertTrue(error is WeatherAppError.RequestError)
            XCTAssertEqual(error as? WeatherAppError.RequestError, WeatherAppError.RequestError.badResponse)
        }
    }
    
    func testGetForecastNoKey() async throws {
        api = OpenWeatherAPI(handler: URLSessionHandlerMockNoKey())
        
        do {
            _ = try await api.getWeather(path: .forecast, city: "London", as: ForecastResponse.self, apiKey: "")
        } catch {
            XCTAssertTrue(error is WeatherAppError.RequestError)
            XCTAssertEqual(error as? WeatherAppError.RequestError, WeatherAppError.RequestError.unauthorized)
        }
    }
    
    func testGetWeatherNoKey() async throws {
        api = OpenWeatherAPI(handler: URLSessionHandlerMockNoKey())
        
        do {
            _ = try await api.getWeather(path: .weather, city: "London", as: CurrentResponse.self, apiKey: "")
        } catch {
            XCTAssertTrue(error is WeatherAppError.RequestError)
            XCTAssertEqual(error as? WeatherAppError.RequestError, WeatherAppError.RequestError.unauthorized)
        }
    }
    
    func testBadQuery() async throws {
        api = OpenWeatherAPI(handler: URLSessionHandlerMockBadQuery())
        
        do {
            _ = try await api.getWeather(path: .weather, city: "London", as: CurrentResponse.self)
        } catch {
            XCTAssertTrue(error is WeatherAppError.RequestError)
            XCTAssertEqual(error as? WeatherAppError.RequestError, WeatherAppError.RequestError.cannotBuildValidURL(path: "weather"))
        }
    }
    
    func testBadResponse() async throws {
        api = OpenWeatherAPI(handler: URLSessionHandlerMockBadResponse())
        
        do {
            _ = try await api.getWeather(path: .weather, city: "London", as: CurrentResponse.self)
        } catch {
            XCTAssertTrue(error is WeatherAppError.RequestError)
            XCTAssertEqual(error as? WeatherAppError.RequestError, WeatherAppError.RequestError.badResponse)
        }
    }
    
    func testCodeError() async throws {
        let statusCode = 404
        
        api = OpenWeatherAPI(handler: URLSessionHandlerMockBacStatusCode(statusCode))
        
        do {
            _ = try await api.getWeather(path: .weather, city: "London", as: CurrentResponse.self)
        } catch {
            XCTAssertTrue(error is WeatherAppError.RequestError)
            XCTAssertEqual(error as? WeatherAppError.RequestError, WeatherAppError.RequestError.clientError(statusCode: 404))
        }
    }
    
    func testDecodeError() async throws {
        api = OpenWeatherAPI(handler: URLSessionHandlerMockEmptyData())
        
        do {
            _ = try await api.getWeather(path: .weather, city: "London", as: CurrentResponse.self)
        } catch {
            XCTAssertTrue(error is WeatherAppError.DecodeError)
            XCTAssertEqual(error as? WeatherAppError.DecodeError, WeatherAppError.DecodeError.cannotDecodeData)
        }
    }
}
