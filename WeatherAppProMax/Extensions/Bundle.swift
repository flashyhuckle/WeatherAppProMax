import Foundation

extension Bundle {
    var apiKey: String {
        infoDictionary?["OpenWeatherApiKey"] as? String ?? ""
    }
    
    var apiBaseUrl: URL {
        guard let baseURL = infoDictionary?["OpenWeatherApiBaseURL"] as? String, let url = URL(string: baseURL) else {
            fatalError("Invalid base URL")
        }
        
        return url
    }
}
