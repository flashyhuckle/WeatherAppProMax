import SwiftUI

struct DailyForecastView: View {
    let dayForecast: [DayForecastModel]
    var body: some View {
        ForEach(dayForecast, id: \.self) { forecast in
            DailyForecastSubview(
                dayName: forecast.dayString,
                icon: forecast.systemIcon,
                tempMax: forecast.maxtemperatureString,
                tempMin: forecast.mintemperatureString
            )
        }
    }
}

struct DailyForecastSubview: View {
    let dayName: String
    let icon: String
    let tempMax: String
    let tempMin: String
    var body: some View {
        ZStack {
            Image(systemName: icon)
                .opacityFont(size: .small)
            HStack {
                
                Text(dayName)
                    .opacityFont(size: .small)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                Spacer()
                Text(tempMax)
                    .opacityFont(size: .small)
                    .frame(width: .xsmall + .medium, height: .small, alignment: .trailing)
                Text(tempMin)
                    .opacityFont(size: .small, opacity: 0.8)
                    .frame(width: .xsmall + .medium, height: .small, alignment: .trailing)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
            }
        }
        .padding(EdgeInsets(top: .small / 4, leading: .small, bottom: .small / 4, trailing: .small))
    }
}
