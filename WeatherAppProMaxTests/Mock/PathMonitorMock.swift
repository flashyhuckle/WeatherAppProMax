@testable import WeatherAppProMax

final class PathMonitorMock: PathMonitorType {
    var isNetworkOn: Bool = false
    
    init() {
        self.isNetworkOn = true
    }
    
    deinit {
        self.isNetworkOn = false
    }
}
