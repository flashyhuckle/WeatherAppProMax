import XCTest
@testable import WeatherAppProMax

final class MainViewViewModelTests: XCTestCase {
    private var vm: MainViewViewModel!
    private let repository = WeatherRepositoryMock()
    private let storage = StorageMock()
    
    override func setUpWithError() throws {
        vm = MainViewViewModel(storage: storage, repository: repository)
    }
    
    func testRefreshWeather() {
        XCTAssertTrue(vm.weathers.isEmpty)
        
        vm.refreshWeather(for: "London")
        
//        XCTAssertFalse(vm.weathers.isEmpty)
    }
    
}
