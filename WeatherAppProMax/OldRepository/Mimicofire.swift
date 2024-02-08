import Foundation

public let MF = Mimicofire()

public struct Mimicofire {
    public func request<T: Decodable>(
        endpoint: URL,
        as type: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: endpoint) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                if let data = data {
                    do {
                        let decoded = try decoder.decode(type, from: data)
                        continuation.resume(returning: decoded)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }.resume()
        }
    }
}
