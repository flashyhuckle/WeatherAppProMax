import SwiftUI

struct WeatherView: View {
    @StateObject var vm: WeatherViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                WeatherMainView(weather: vm.currentWeather)
                
                DetailWeatherView(weather: vm.currentWeather)
                
                if vm.isForecastLoading {
                    ProgressView()
                        .customPrimaryTint()
                        .scaleEffect(CGSize(width: 2.0, height: 2.0), anchor: .top)
                } else {
                    if !vm.hourForecast.isEmpty {
                        Divider()
                        HourForecastView(hourForecast: vm.hourForecast)
                    }
                    
                    if !vm.dayForecast.isEmpty {
                        Divider()
                        DailyForecastView(dayForecast: vm.dayForecast)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    GridBackButton()
                }
            }
            .onAppear {
                Task { 
                    await vm.refreshForecast()
                }
            }
            
            .navigationBarBackButtonHidden()
            .navigationTitle(vm.currentWeather.cityName)
            .navigationBarTitleDisplayMode(.inline)
            .customPrimaryColor()
            
            .frame(maxWidth: .infinity)
            .background(makeGradient())
            
            .refreshable {
                await vm.forceRefresh()
            }
        }
    }
    
    private func makeGradient() -> LinearGradient {
        return WeatherGradientMaker.makeGradient(for: vm.currentWeather.weatherType)
    }
}
