import SwiftUI

struct HourForecastView: View {
    let hourForecast: [HourForecastModel]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(hourForecast, id: \.self) { forecast in
                    HourForecastSubview(
                        hour: forecast.hourString,
                        temperature: forecast.temperatureString,
                        icon: forecast.systemIcon
                    )
                }
            }
        }.scrollIndicators(.hidden)
    }
}

struct HourForecastSubview: View {
    let hour: String
    let temperature: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(hour)
                .opacityFont(size: .medium, opacity: 0.5)
            HStack {
                Text(temperature)
                    .opacityFont(size: .medium)
                Image(systemName: icon)
                    .opacityFont(size: .small)
            }
        }
        .padding()
    }
}
