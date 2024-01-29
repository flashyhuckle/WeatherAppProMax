import SwiftUI
import SwiftData

struct Forecast: Hashable {
    let hour: String
    let temperature: String
}

struct WeatherView: View {
    @Environment(\.dismiss) var dismiss
    @State private var color1: Color = .teal
    
    let city: String
    @StateObject var vm: WeatherViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                HStack(spacing: 10) {
                    Spacer()
                    WeatherMainView(
                        cityName: vm.currentWeather.cityName,
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
                    DetailForecastViewData(iconName: "humidity", label: "Humidity", data: "\(vm.currentWeather.humidity)%"),
                    DetailForecastViewData(iconName: "barometer", label: "Pressure", data: vm.currentWeather.pressureString),
                    DetailForecastViewData(iconName: "eye.circle", label: "Visibility", data: "\(vm.currentWeather.visibility/1000) km")
                ])
                Divider()
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(vm.forecast, id: \.self) { forecast in
                            HourForecastSubview(hour: forecast.hourString, temperature: forecast.temperatureString)
                        }
                    }
                }.scrollIndicators(.hidden)
                
                Divider()
                ForEach(vm.forecast, id: \.self) { forecast in
                    WeeklyForecastSubview(
                        dayName: forecast.date.formatted(Date.FormatStyle().weekday(.wide)),
                        icon: forecast.systemIcon,
                        tempMax: forecast.maxtemperatureString,
                        tempMin: forecast.mintemperatureString
                    )
                }
            }
            
            .navigationBarBackButtonHidden()
            
            .foregroundStyle(.white)
            .toolbarBackground(color1, for: .navigationBar)
            
            .frame(maxWidth: .infinity)
            .background(makeGradient())
            
            .refreshable {
                vm.forceRefresh(for: city)
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
                    }.tint(.white)
                }
            }
            .onAppear {
                vm.refreshWeather(for: city)
            }
        }
    }
    
    private func makeGradient() -> LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [color1, .blue]), startPoint: .top, endPoint: .bottom)
    }
}

struct DetailForecastViewData: Hashable {
    let iconName: String
    let label: String
    let data: String
}

struct DetailForecastView: View {
    
    let data: [DetailForecastViewData]
    
    var body: some View {
        HStack {
            ForEach(data, id: \.self) { data in
                DetailForecastSubview(iconName: data.iconName, label: data.label, data: data.data)
            }
        }
    }
}

struct DetailForecastSubview: View {
    let iconName: String
    let label: String
    let data: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .padding()
            Text(label)
                .font(.subheadline)
            Text(data)
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        }
        .foregroundStyle(.white)
        .padding()
    }
}

struct HourForecastSubview: View {
    let hour: String
    let temperature: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(hour)
                .font(.callout)
//                .foregroundStyle(.white)
                .opacity(0.5)
            Text(temperature)
                .font(.title)
//                .foregroundStyle(.white)
        }.padding()
    }
}

struct WeatherMainView: View {
    let cityName: String
    let temperature: String
    let maxTemp: String
    let minTemp: String
    let description: String
    let feelsLike: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            Text(cityName)
                .font(.system(size: 25))
//                .padding(.vertical)
            VStack(alignment: .leading) {
                Text(temperature)
                    .font(.system(size: 80))
                
                HStack {
                    HStack {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 12))
                            .opacity(0.8)
                        Text(maxTemp)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    
                    HStack {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .opacity(0.8)
                        Text(minTemp)
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text(description)
                    .font(.system(size: 20))
                    .frame(width: 160, height: 30, alignment: .leading)
                    .minimumScaleFactor(0.5)
                Text("feels like \(feelsLike)")
                    .font(.system(size: 15))
                    .opacity(0.8)
            }
            .padding(.vertical)
        }
//        .background(.red)
    }
}

struct WeatherIconView: View {
    let icon: String
    
    var body: some View {
        ZStack {
            Circle()
//                .foregroundStyle(.white)
                .opacity(0.05)
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .fontWeight(.thin)
//                .foregroundStyle(.white)
                .padding(40)
        }
//        .background(.red)
        .offset(x: 30)
    }
}

struct WeeklyForecastView: View {
    var body: some View {
        VStack {
            
        }
    }
}

struct WeeklyForecastSubview: View {
    let dayName: String
    let icon: String
    let tempMax: String
    let tempMin: String
    var body: some View {
        ZStack {
            Image(systemName: icon)
            HStack {
                Text(dayName)
                Spacer()
                Text(tempMax)
                    .frame(width: 30, height: 20, alignment: .trailing)
                Text(tempMin)
                    .opacity(0.8)
                    .frame(width: 30, height: 20, alignment: .trailing)
            }
        }
        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
    }
}

//#Preview {
//    WeatherView(city: WeatherModel.example.cityName, vm: WeatherViewModel(container: ModelContainer()))
//        .modelContainer(for: [WeatherModel.self], inMemory: true)
//}
