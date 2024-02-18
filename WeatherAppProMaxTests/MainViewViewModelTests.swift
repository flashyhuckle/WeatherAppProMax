import XCTest
@testable import WeatherAppProMax

@MainActor
final class MainViewViewModelTests: XCTestCase {
    private let repository = WeatherRepositoryMock()
    private let storage = StorageMock()
    
    func testRefreshWeather() async {
        let vm = MainViewViewModel(storage: storage, repository: repository)
        
        //array is empty at initial test = we have no models
        XCTAssertTrue(vm.weathers.isEmpty)
        
        //refreshing weather from repository
        vm.textfieldText = "London"
        await vm.addNewButtonPressed()
        
        //array is no longer empty
        XCTAssertFalse(vm.weathers.isEmpty)
    }
    
    func testRemoveCity() async {
        let vm = MainViewViewModel(storage: storage, repository: repository)
        
        //array should be empty
        XCTAssertTrue(vm.weathers.isEmpty)
        
        //refreshing weather from repository
        vm.textfieldText = "London"
        await vm.addNewButtonPressed()
        
        //array is not empty
        XCTAssertFalse(vm.weathers.isEmpty)
        
        //removing weather we got from vm.refreshWeather
        vm.remove(city: "London")
        
        //array should be empty
        XCTAssertTrue(vm.weathers.isEmpty)
    }
    
    func testLoadData() {
        //creating sample weather
        let weather = Weather.example
        
        //saving sample to storage
        storage.saveObject(weather)
        
        let vm = MainViewViewModel(storage: storage, repository: repository)
        
        //weathers is no longer empty
        XCTAssertFalse(vm.weathers.isEmpty)
        
        //loaded model is the same as the one we created
        XCTAssertEqual(vm.weathers.first, weather)
    }
    
    func testRefreshWeatherFromStorage() async {
        //creating sample weather
        let weather = Weather.example
        
        //saving sample to storage
        storage.saveObject(weather)
        
        //loading from storage into viewmodel
        let vm = MainViewViewModel(storage: storage, repository: repository)
        
        //saving weather refresh date locally
        let weatherRefreshDate1 = vm.weathers.first?.currentRefreshDate
        
        //checking if we got back our sample
        XCTAssertEqual(weather.currentRefreshDate, weatherRefreshDate1)
        
        //refreshing weather - shouldn't be refreshed
        await vm.onAppear()
        
        //saving weather refresh date again
        let weatherRefreshDate2 = vm.weathers.first?.currentRefreshDate
        
        //dates should be equal
        XCTAssertEqual(weatherRefreshDate1, weatherRefreshDate2)
    }
    
    func testRefreshWeatherWithPreviousData() async {
        //creating sample weather
        let weather = Weather.example
        
        //weather refresh date is 1 second older than required 10 minutes
        weather.currentRefreshDate = Date.now - TimeInterval(601)
        
        //saving sample to storage
        storage.saveObject(weather)
        
        //loading from storage into viewmodel
        let vm = MainViewViewModel(storage: storage, repository: repository)
        
        //saving weather refresh date locally
        let weatherRefreshDate1 = vm.weathers.first?.currentRefreshDate
        
        //checking if we got back our sample
        XCTAssertEqual(weather.currentRefreshDate, weatherRefreshDate1)
        
        //refreshing weather - should be refreshed
        await vm.onAppear()
        
        //saving weather refresh date again
        let weatherRefreshDate2 = vm.weathers.first?.currentRefreshDate
        
        //dates shouldn't be equal
        XCTAssertNotEqual(weatherRefreshDate1, weatherRefreshDate2)
    }
    
    func testForceRefresh() async {
        //creating sample weather
        let weather = Weather.example
        
        //saving sample to storage
        storage.saveObject(weather)
        
        //loading from storage into viewmodel
        let vm = MainViewViewModel(storage: storage, repository: repository)
        
        //saving weather refresh date locally
        let weatherRefreshDate1 = vm.weathers.first?.currentRefreshDate
        
        //checking if we got back our sample
        XCTAssertEqual(weather.currentRefreshDate, weatherRefreshDate1)
        
        //we should have 1 weather
        XCTAssertEqual(vm.weathers.count, 1)
        
        await vm.refresh()
        
        //saving weather refresh date again
        let weatherRefreshDate2 = vm.weathers.first?.currentRefreshDate
        
        //dates shouldn't be equal
        XCTAssertNotEqual(weatherRefreshDate1, weatherRefreshDate2)
        
        //we still should have 1 weather
        XCTAssertEqual(vm.weathers.count, 1)
    }
    
    func testToolbarAddButtonPressed() {
        let vm = MainViewViewModel(storage: storage, repository: repository)
        
        XCTAssertFalse(vm.addAlertShowing)
        
        vm.toolbarAddButtonPressed()
        
        XCTAssertTrue(vm.addAlertShowing)
    }
    
    func testToolbarEditButtonPressed() {
        let vm = MainViewViewModel(storage: storage, repository: repository)
        
        XCTAssertFalse(vm.isEditEnabled)
        
        vm.toolbarEditButtonPressed()
        
        XCTAssertTrue(vm.isEditEnabled)
    }
    
    func testToolbarEditButtonPressedAgain() {
        let vm = MainViewViewModel(storage: storage, repository: repository)
        
        XCTAssertFalse(vm.isEditEnabled)
        
        vm.toolbarEditButtonPressed()
        
        XCTAssertTrue(vm.isEditEnabled)
        
        vm.toolbarEditButtonPressed()
        
        XCTAssertFalse(vm.isEditEnabled)
    }
    
    func testAddNewButtonPressed() async {
        let vm = MainViewViewModel(storage: storage, repository: repository)
        
        XCTAssertTrue(vm.weathers.isEmpty)
        
        vm.textfieldText = "London"
        await vm.addNewButtonPressed()
        
        XCTAssertFalse(vm.weathers.isEmpty)
        XCTAssertTrue(vm.textfieldText.isEmpty)
        XCTAssertFalse(vm.addAlertShowing)
    }
    
    func testCancelButtonPressed() {
        let vm = MainViewViewModel(storage: storage, repository: repository)
        
        vm.addAlertShowing = true
        vm.textfieldText = "Test"
        
        vm.cancelButtonPressed()
        
        XCTAssertFalse(vm.addAlertShowing)
        XCTAssertTrue(vm.textfieldText.isEmpty)
        
    }
    
}
