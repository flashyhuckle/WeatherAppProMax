import SwiftUI

struct MainViewTile: View {
    let weather: WeatherModel
    
    @StateObject var vm: MainViewViewModel
    
    var body: some View {
        NavigationLink {
            WeatherView(
                city: weather.cityName,
                vm: WeatherViewModel(
                    storage: vm.storage
                )
            )
        } label: {
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                    .foregroundStyle(.teal)
                VStack {
                    Text(weather.cityName)
                    HStack {
                        Text(weather.temperatureString)
                        Image(systemName: weather.systemIcon)
                    }
                }
                .foregroundStyle(.white)
            }
            .frame(width: 150, height: 150)
        }
        .onAppear(perform: {
            vm.refreshWeather(for: weather.cityName)
        })
    }
}
