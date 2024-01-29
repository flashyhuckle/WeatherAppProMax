import Foundation

struct CurrentResponse: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
    let sys: Sys
    let wind: Wind
    let visibility: Int
    let timezone: Int
    let dt: Int
    
    struct Weather: Decodable {
        let icon: String
        let description: String
    }
    
    struct Main: Decodable {
        let temp: Float
        let feels_like: Float
        let pressure: Int
        let humidity: Int
        let temp_min: Float
        let temp_max: Float
    }
    
    struct Sys: Decodable {
        let country: String
        let sunrise: Int
        let sunset: Int
    }
    
    struct Wind: Decodable {
        let speed: Float
    }
}
