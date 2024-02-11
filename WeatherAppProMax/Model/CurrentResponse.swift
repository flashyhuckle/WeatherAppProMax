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
    
    static let example = CurrentResponse(
        weather: [
            Weather(
                icon: "03n",
                description: "scattered clouds"
            )],
        main: Main(
            temp: 282.47,
            feels_like: 280.79,
            pressure: 994,
            humidity: 80,
            temp_min: 280.64,
            temp_max: 283.35
        ),
        name: "London",
        sys: Sys(
            country: "GB",
            sunrise: 1707636197,
            sunset: 1707671181
        ),
        wind: Wind(
            speed: 3.09
        ),
        visibility: 10000,
        timezone: 0,
        dt: 1707672453
    )
}
