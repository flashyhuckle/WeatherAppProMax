import Foundation

public extension Float {
    func toString() -> String {
        let temp = String(format: "%.0f", self) + "°"
        if temp == "-0°" {
            return "0°"
        } else {
            return temp
        }
    }
}
