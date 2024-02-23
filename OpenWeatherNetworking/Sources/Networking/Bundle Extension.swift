import Foundation

extension Bundle {
    public var apiKey: String {
        infoDictionary?["OpenWeatherApiKey"] as? String ?? ""
    }
    
    public var apiBaseUrl: URL {
        guard let baseURL = infoDictionary?["OpenWeatherApiBaseURL"] as? String, let url = URL(string: baseURL) else {
            fatalError("Invalid base URL")
        }
        
        return url
    }
}
