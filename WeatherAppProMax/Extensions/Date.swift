import Foundation

public extension Date {
    func hourString() -> String {
        self.formatted(Date.FormatStyle().hour())
    }
    
    func shortDateString() -> String {
        self.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits))
    }
    
    func dateString() -> String {
        self.formatted(Date.FormatStyle().weekday(.wide).month(.wide).day(.twoDigits))
    }
    
    func dayString() -> String {
        self.formatted(Date.FormatStyle().weekday(.wide))
    }
}
