import SwiftUI

struct MainViewTile: View {
    let weather: WeatherModel
    
    @StateObject var vm: MainViewViewModel
    
    var body: some View {
        NavigationLink {
            WeatherView(
                city: weather.cityName,
                vm: WeatherViewModel(storage: vm.storage)
            )
        } label: {
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: Int(CGFloat.medium), height: Int(CGFloat.medium)))
                    .customSecondaryColor()
                VStack(alignment: .leading) {
                    HStack {
                        Text(weather.temperatureString)
                        Spacer()
                        Image(systemName: weather.systemIcon)
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
        .onAppear(perform: {
            vm.refreshWeather(for: weather.cityName)
        })
    }
}
