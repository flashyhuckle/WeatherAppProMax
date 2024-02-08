import SwiftUI

struct WeatherGradientMaker {
    func makeGradient(for weather: WeatherType) -> LinearGradient {
        switch weather {
        case .hot:
            UINavigationBar.appearance().backgroundColor = .orange
            return LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .top, endPoint: .bottom)
        case .warm:
            UINavigationBar.appearance().backgroundColor = .yellow
            return LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: .top, endPoint: .bottom)
        case .mild:
            UINavigationBar.appearance().backgroundColor = .green
            return LinearGradient(gradient: Gradient(colors: [.green, .yellow]), startPoint: .top, endPoint: .bottom)
        case .cold:
            UINavigationBar.appearance().backgroundColor = .orange
            return LinearGradient(gradient: Gradient(colors: [.teal, .green]), startPoint: .top, endPoint: .bottom)
        case .freezing:
            UINavigationBar.appearance().backgroundColor = .orange
            return LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: .top, endPoint: .bottom)
        }
        
    }
}

struct WeatherView: View {
    @Environment(\.dismiss) var dismiss
    
    let city: String
    @StateObject var vm: WeatherViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                HStack(spacing: 10) {
                    Spacer()
                    WeatherMainView(
                        temperature: vm.currentWeather.temperatureString,
                        maxTemp: vm.currentWeather.maxtemperatureString,
                        minTemp: vm.currentWeather.mintemperatureString,
                        description: vm.currentWeather.descriptionString,
                        feelsLike: vm.currentWeather.feelsLikeString
                    )
                    WeatherIconView(
                        icon: vm.currentWeather.systemIcon
                    )
                }
                
                DetailForecastView(data: [
                    DetailForecastViewData(iconName: "wind", label: "Wind", data: vm.currentWeather.windSpeedString),
                    DetailForecastViewData(iconName: "eye.circle", label: "Visibility", data: "\(vm.currentWeather.visibility/1000) km"),
                    DetailForecastViewData(iconName: "humidity", label: "Humidity", data: "\(vm.currentWeather.humidity)%"),
                    DetailForecastViewData(iconName: "sunrise", label: "Sunrise", data: vm.currentWeather.sunriseString),
                    DetailForecastViewData(iconName: "barometer", label: "Pressure", data: vm.currentWeather.pressureString),
                    DetailForecastViewData(iconName: "sunset", label: "Sunset", data: vm.currentWeather.sunsetString)
                ])
                Divider()
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(vm.hourForecast, id: \.self) { forecast in
                            HourForecastSubview(hour: forecast.hourString, temperature: forecast.temperatureString)
                        }
                    }
                }.scrollIndicators(.hidden)
                
                Divider()
                ForEach(vm.dayForecast, id: \.self) { forecast in
                    WeeklyForecastSubview(
                        dayName: forecast.date.formatted(Date.FormatStyle().weekday(.wide)),
                        icon: forecast.systemIcon,
                        tempMax: forecast.maxtemperatureString,
                        tempMin: forecast.mintemperatureString
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Image(systemName: "square.grid.2x2")
                        }
                    }
                }
            }
            .onAppear {
                vm.refreshWeather(for: city)
            }
            
            .navigationBarBackButtonHidden()
            .navigationTitle(vm.currentWeather.cityName)
            .navigationBarTitleDisplayMode(.large)
            .foregroundStyle(.white)
            
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

