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

public extension CGFloat {
    static var xxsmall: CGFloat = 10
    static var xsmall: CGFloat = 15
    static var small: CGFloat = 20
    static var medium: CGFloat = 30
    static var large: CGFloat = 50
    static var xlarge: CGFloat = 80
}
