
enum WeatherAppError: Error, Equatable {
    enum NetworkError: Error, Equatable  {
        case noConnection
    }
    
    enum RequestError: Error, Equatable  {
        case cannotBuildValidURL(path: String)
        case badResponse
        case unauthorized
        case clientError(statusCode: Int)
        case serverError(statusCode: Int)
    }

    enum DecodeError: Error, Equatable  {
        case cannotDecodeData
    }
    
    enum DataStorageError: Error, Equatable  {
        case modelContainerNotInitialized
        case saveError
        case loadError
        case insertError
        case deleteError
    }
}
