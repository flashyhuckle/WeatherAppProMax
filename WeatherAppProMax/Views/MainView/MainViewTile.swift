import SwiftUI

struct MainViewTile: View {
    let weather: Weather
    
    var body: some View {
        NavigationLink {
            WeatherView(
                vm: WeatherViewModel(weather: weather)
            )
        } label: {
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: Int(CGFloat.medium), height: Int(CGFloat.medium)))
                    .customSecondaryColor()
                VStack(alignment: .leading) {
                    HStack {
                        Text(weather.currentWeather.temperatureString)
                        Spacer()
                        Image(systemName: weather.currentWeather.systemIcon)
                    }
                    .opacityFont(size: .medium)
                    VStack(alignment: .leading) {
                        Text(weather.cityName)
                            .opacityFont(size: .medium)
                            .frame(width: .xlarge + .large, height: .medium + 5, alignment: .leading)
                            .minimumScaleFactor(0.5)
                        Text(weather.country)
                            .opacityFont(size: .small, opacity: 0.5)
                    }
                }
                .padding(.xsmall)
                .customPrimaryColor()
            }
            .frame(width: .xlarge * 2, height: .xlarge * 2)
        }
    }
}
