import SwiftUI

struct WeatherView: View {
    
    let city: String
    @StateObject var vm: WeatherViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                WeatherMainView(weather: vm.currentWeather)
                
                DetailWeatherView(weather: vm.currentWeather)
                
                if !vm.hourForecast.isEmpty {
                    Divider()
                    HourForecastView(hourForecast: vm.hourForecast)
                }
                
                if !vm.dayForecast.isEmpty {
                    Divider()
                    DailyForecastView(dayForecast: vm.dayForecast)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    GridBackButton()
                }
            }
            .onAppear {
                vm.refreshForecast(for: city)
            }
            
            .navigationBarBackButtonHidden()
            .navigationTitle(vm.currentWeather.cityName)
            .customPrimaryColor()
            
            .frame(maxWidth: .infinity)
            .background(makeGradient())
            
            .refreshable {
                vm.forceRefresh(for: city)
            }
        }
    }
    
    private func makeGradient() -> LinearGradient {
        return WeatherGradientMaker().makeGradient(for: vm.currentWeather.weatherType)
    }
}
