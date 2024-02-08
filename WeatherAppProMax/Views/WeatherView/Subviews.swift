import SwiftUI

struct DetailForecastViewData: Hashable {
    let iconName: String
    let label: String
    let data: String
}

struct DetailForecastView: View {
    let data: [DetailForecastViewData]
    
    var body: some View {
        LazyHGrid(rows: [GridItem(.flexible()), GridItem(.flexible())]) {
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
                .font(.system(size: 25))
            Text(label)
                .font(.subheadline)
            Text(data)
                .opacity(0.8)
        }
        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
    }
}

struct HourForecastSubview: View {
    let hour: String
    let temperature: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(hour)
                .font(.callout)
                .opacity(0.5)
            Text(temperature)
                .font(.title)
        }.padding()
    }
}

struct WeatherMainView: View {
    let temperature: String
    let maxTemp: String
    let minTemp: String
    let description: String
    let feelsLike: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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
                .padding(40)
        }
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
