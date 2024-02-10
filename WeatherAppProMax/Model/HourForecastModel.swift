import Foundation

struct HourForecastModel: Codable, Hashable {
    let cityName: String
    let date: Date
    let temperature: Float
    let systemIcon: String
    
    var temperatureString: String {
        temperature.toString()
    }
    
    var hourString: String {
        date.hourString()
    }
}
