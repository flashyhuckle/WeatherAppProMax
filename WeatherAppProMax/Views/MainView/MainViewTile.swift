import SwiftUI

struct MainViewTile: View {
    let vm: MainViewTileViewModel
    
    var body: some View {
        NavigationLink {
            WeatherView(
                vm: WeatherViewModel(weather: vm.weather)
            )
        } label: {
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: Int(CGFloat.medium), height: Int(CGFloat.medium)))
                    .customSecondaryColor()
                VStack(alignment: .leading) {
                    HStack {
                        Text(vm.weather.currentWeather.temperatureString)
                        Spacer()
                        Image(systemName: vm.weather.currentWeather.systemIcon)
                    }
                    .opacityFont(size: .medium)
                    VStack(alignment: .leading) {
                        Text(vm.weather.cityName)
                            .opacityFont(size: .medium)
                            .frame(width: .xlarge + .large, height: .medium + 5, alignment: .leading)
                            .minimumScaleFactor(0.5)
                        Text(vm.weather.country)
                            .opacityFont(size: .small, opacity: 0.5)
                    }
                }
                .padding(.xsmall)
                .customPrimaryColor()
            }
            .frame(width: .xlarge * 2, height: .xlarge * 2)
            
            .refreshable {
                vm.refresh()
            }
            .onAppear {
                vm.onAppear()
            }
        }
        
    }
}
