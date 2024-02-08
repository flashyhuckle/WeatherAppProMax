import Foundation

extension String {
    public func getTemperatureString(from temperature: Float) -> String {
        let temp = String(format: "%.0f", temperature) + "°"
        if temp == "-0°" {
            return "0°"
        } else {
            return temp
        }
    }
}
