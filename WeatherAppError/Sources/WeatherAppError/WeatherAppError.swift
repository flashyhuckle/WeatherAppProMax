public enum NetworkError: Error, Equatable  {
    case noConnection
}

public enum RequestError: Error, Equatable  {
    case cannotBuildValidURL(path: String)
    case badResponse
    case unauthorized
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
}

public enum DecodeError: Error, Equatable  {
    case cannotDecodeData
}

public enum DataStorageError: Error, Equatable  {
    case modelContainerNotInitialized
    case saveError
    case loadError
    case insertError
    case deleteError
}
