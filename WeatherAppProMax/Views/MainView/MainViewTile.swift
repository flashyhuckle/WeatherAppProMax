import SwiftUI

struct MainViewTile: View {
    let weather: WeatherModel
    
    @StateObject var vm: MainViewViewModel
    
    var body: some View {
        NavigationLink {
            WeatherView(
                city: weather.cityName,
                vm: WeatherViewModel()
            )
        } label: {
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                    .foregroundStyle(.teal)
                VStack(alignment: .leading) {
                    HStack {
                        Text(weather.temperatureString)
                        Spacer()
                        Image(systemName: weather.systemIcon)
                    }
                    .font(.system(size: 25))
                    .padding()
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(weather.cityName)
                            .font(.system(size: 20))
                        Text(weather.country)
                            .font(.system(size: 20))
                            .opacity(0.5)
                    }
                    .padding()
                    
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
