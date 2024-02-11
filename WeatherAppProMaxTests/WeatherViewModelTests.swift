import XCTest
@testable import WeatherAppProMax

final class WeatherViewModelTests: XCTestCase {
    private var vm: WeatherViewModel!
    private let repository = ForecastRepositoryMock()
    private let storage = StorageMock()
    
    override func setUpWithError() throws {
        vm = WeatherViewModel(storage: storage, repository: repository)
    }
  
    
}
