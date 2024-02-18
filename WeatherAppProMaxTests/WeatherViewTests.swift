import SnapshotTesting
import XCTest
import SwiftUI

@testable import WeatherAppProMax

@MainActor
final class WeatherViewTests: XCTestCase {
    
    func testWeatherViewNoAction() {
        let repository = ForecastRepositoryMock()
        let weather = Weather.makeMock()
        let view = WeatherView(vm: WeatherViewModel(repository: repository, weather: weather))
        
        assertSnapshot(of: view, as: .image)
    }
    
    func testWeatherViewForceRefresh() async {
        let repository = ForecastRepositoryMock()
        let weather = Weather.makeMock()
        let vm = WeatherViewModel(repository: repository, weather: weather)
        let view = WeatherView(vm: vm)
        
        await vm.forceRefresh()
        
        assertSnapshot(of: view, as: .image)
    }
}
