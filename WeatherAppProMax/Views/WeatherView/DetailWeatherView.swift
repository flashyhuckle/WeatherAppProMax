import SwiftUI

struct DetailForecastViewData: Hashable {
    let iconName: String
    let label: String
    let data: String
}

struct DetailWeatherView: View {
    let weather: WeatherModel
    
    var data: [DetailForecastViewData] {
        [
            DetailForecastViewData(iconName: "wind", label: "Wind", data: weather.windSpeedString),
            DetailForecastViewData(iconName: "eye.circle", label: "Visibility", data: weather.visibilityString),
            DetailForecastViewData(iconName: "humidity", label: "Humidity", data: weather.humidityString),
            DetailForecastViewData(iconName: "sunrise", label: "Sunrise", data: weather.sunriseString),
            DetailForecastViewData(iconName: "barometer", label: "Pressure", data: weather.pressureString),
            DetailForecastViewData(iconName: "sunset", label: "Sunset", data: weather.sunsetString)
        ]
    }
    
    var body: some View {
        LazyHGrid(rows: getRows()) {
            ForEach(data, id: \.self) { data in
                DetailWeatherSubview(iconName: data.iconName, label: data.label, data: data.data)
            }
        }
    }
    
    private func getRows() -> [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            [GridItem(.flexible())]
        } else {
            [GridItem(.flexible()), GridItem(.flexible())]
        }
    }
}

struct DetailWeatherSubview: View {
    let iconName: String
    let label: String
    let data: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .opacityFont(size: .small)
            Text(label)
                .opacityFont(size: .xsmall)
            Text(data)
                .opacityFont(size: .small, opacity: 0.8)
        }
        .padding(EdgeInsets(top: .xxsmall, leading: .medium, bottom: .xxsmall, trailing: .medium))
    }
}
