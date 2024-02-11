import Foundation

struct ForecastResponse: Decodable {
    let list: [List]
    let city: City
    let cnt: Int

    struct List: Decodable {
        let dt: Int
        let main: Main
        let weather: [Weather]
        let wind: Wind
        let visibility: Int
    }

    struct Main: Decodable {
        let temp: Float
        let feels_like: Float
        let temp_min: Float
        let temp_max: Float
        let pressure: Int
        let humidity: Int
    }

    struct Weather: Decodable {
        let main: String
        let description: String
        let icon: String
    }
    
    struct Wind: Decodable {
        let speed: Float
    }

    struct City: Decodable {
        let name: String
        let country: String
        let sunrise: Int
        let sunset: Int
        let timezone: Int
    }
    
    static let example = ForecastResponse(
        list: [
            List(
                dt: 1707674400,
                main: Main(
                    temp: 282.18,
                    feels_like: 280.11,
                    temp_min: 281.73,
                    temp_max: 282.18,
                    pressure: 994,
                    humidity: 80
                ),
                weather: [
                    Weather(
                        main: "Clouds",
                        description: "scattered clouds",
                        icon: "03n"
                    )],
                wind: Wind(
                    speed: 3.69
                ),
                visibility: 10000
            )],
        city: City(
            name: "London",
            country: "GB",
            sunrise: 1707636197,
            sunset: 1707671181,
            timezone: 0
        ),
        cnt: 5
    )
}
