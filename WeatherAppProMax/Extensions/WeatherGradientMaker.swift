import SwiftUI

public struct WeatherGradientMaker {
    static func makeGradient(for weatherType: WeatherType) -> LinearGradient {
        switch weatherType {
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
            UINavigationBar.appearance().backgroundColor = UIColor(.teal)
            return LinearGradient(gradient: Gradient(colors: [.teal, .green]), startPoint: .top, endPoint: .bottom)
        case .freezing:
            UINavigationBar.appearance().backgroundColor = UIColor(.teal)
            return LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: .top, endPoint: .bottom)
        }
        
    }
}
