
enum WeatherAppError: Error {
    enum NetworkError: Error {
        case noConnection
    }
    
    enum RequestError: Error {
        case cannotBuildValidURL(path: String, method: HTTPMethod = .GET)
        case badResponse
        case unauthorized
        case clientError(statusCode: Int)
        case serverError(statusCode: Int)
    }

    enum DecodeError: Error {
        case cannotDecodeData
    }
    
    enum DataStorageError: Error {
        case modelContainerNotInitialized
        case saveError
        case loadError
        case insertError
        case deleteError
    }
}
