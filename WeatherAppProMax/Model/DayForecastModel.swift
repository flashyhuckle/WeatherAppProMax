import Foundation

struct DayForecastModel: Codable, Hashable {
    let cityName: String
    let date: Date
    let maxTemperature: Float
    let minTemperature: Float
    let systemIcon: String
    
    var maxtemperatureString: String {
        maxTemperature.toString()
    }
    
    var mintemperatureString: String {
        minTemperature.toString()
    }
    
    var dayString: String {
        date.dayString()
    }
}
