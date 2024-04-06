import SwiftUI

struct WeatherMainView: View {
    let weather: WeatherModel
    
    var body: some View {
        HStack(spacing: .xxsmall) {
            WeatherMainSubview(
                temperature: weather.temperatureString,
                maxTemp: weather.maxtemperatureString,
                minTemp: weather.mintemperatureString,
                description: weather.descriptionString,
                feelsLike: weather.feelsLikeString
            )
            WeatherIconView(icon: weather.systemIcon)
        }
    }
}

struct WeatherMainSubview: View {
    let temperature: String
    let maxTemp: String
    let minTemp: String
    let description: String
    let feelsLike: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: .xxsmall) {
            VStack(alignment: .leading) {
                Text(temperature)
                    .opacityFont(size: .xlarge)
                
                HStack {
                    HStack {
                        Image(systemName: "chevron.up")
                            .opacityFont(size: .xsmall, opacity: 0.8)
                        Text(maxTemp)
                            .opacityFont(size: .small)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: .xxsmall))
                    
                    HStack {
                        Image(systemName: "chevron.down")
                            .opacityFont(size: .xsmall, opacity: 0.8)
                        Text(minTemp)
                            .opacityFont(size: .small)
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text(description)
                    .opacityFont(size: .small)
                    .frame(width: .xlarge * 2, height: .medium, alignment: .leading)
                    .minimumScaleFactor(0.5)
                Text("feels like \(feelsLike)")
                    .opacityFont(size: .xsmall, opacity: 0.8)
            }
            
        }
        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
    }
}

struct WeatherIconView: View {
    let icon: String
    
    var body: some View {
        ZStack {
            Circle()
                .opacity(0.05)
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .fontWeight(.thin)
                .padding(.xlarge / 2)
        }
        .frame(maxWidth: .large * 5, maxHeight: .large * 5)
    }
}

struct GridBackButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
