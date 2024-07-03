import Foundation

@testable import WeatherAppProMax

final class URLSessionHandlerMockForecastData: URLSessionHandlerType {
    func performRequest(path: String, query: [String : String]?) async throws -> Data {
        return ForecastResponse.mockForecastData()
    }
}

final class URLSessionHandlerMockCurrentData: URLSessionHandlerType {
    func performRequest(path: String, query: [String : String]?) async throws -> Data {
        return CurrentResponse.mockCurrentData()
    }
}

final class URLSessionHandlerMockNoKey: URLSessionHandlerType {
    func performRequest(path: String, query: [String : String]?) async throws -> Data {
        throw WeatherAppError.RequestError.unauthorized
    }
}

final class URLSessionHandlerMockEmptyData: URLSessionHandlerType {
    func performRequest(path: String, query: [String : String]?) async throws -> Data {
        return Data()
    }
}

final class URLSessionHandlerMockBadQuery: URLSessionHandlerType {
    func performRequest(path: String, query: [String : String]?) async throws -> Data {
        throw WeatherAppError.RequestError.cannotBuildValidURL(path: path)
    }
}

final class URLSessionHandlerMockBadResponse: URLSessionHandlerType {
    func performRequest(path: String, query: [String : String]?) async throws -> Data {
        throw WeatherAppError.RequestError.badResponse
    }
}

final class URLSessionHandlerMockBacStatusCode: URLSessionHandlerType {
    let statusCode: Int
    
    init(_ statusCode: Int) {
        self.statusCode = statusCode
    }
    
    func performRequest(path: String, query: [String : String]?) async throws -> Data {
        switch statusCode {
        case 401:
            throw WeatherAppError.RequestError.unauthorized
        case 400..<500:
            throw WeatherAppError.RequestError.clientError(statusCode: statusCode)
        case 500...:
            throw WeatherAppError.RequestError.serverError(statusCode: statusCode)
        default:
            break
        }
        
        return Data()
    }
}
