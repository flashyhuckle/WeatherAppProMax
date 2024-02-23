import Foundation

public protocol URLSessionHandlerType {
    func performRequest(
        path: String,
        query: [String: String]?
    ) async throws -> Data
}
