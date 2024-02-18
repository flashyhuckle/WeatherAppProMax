import SnapshotTesting
import XCTest

@testable import WeatherAppProMax

@MainActor
final class MainViewTests: XCTestCase {
    
    func testMainViewNoAction() {
        let storage = StorageMock()
        let repository = WeatherRepositoryMock()
        let vm = MainViewViewModel(storage: storage, repository: repository)
        let view = MainView(vm: vm)
        
        assertSnapshot(of: view, as: .image)
    }
    
    func testMainViewToolbarAddButtonPressed() {
        let storage = StorageMock()
        let repository = WeatherRepositoryMock()
        let vm = MainViewViewModel(storage: storage, repository: repository)
        let view = MainView(vm: vm)
        
        vm.toolbarAddButtonPressed()
        
        assertSnapshot(of: view, as: .image)
    }
    
    func testMainViewAddedCity() async {
        let storage = StorageMock()
        let repository = WeatherRepositoryMock()
        let vm = MainViewViewModel(storage: storage, repository: repository)
        let view = MainView(vm: vm)
        
        vm.textfieldText = "London"
        await vm.addNewButtonPressed()
        
        assertSnapshot(of: view, as: .image)
    }
    
    func testMainViewAddedCityEditButtonPressed() async {
        let storage = StorageMock()
        let repository = WeatherRepositoryMock()
        let vm = MainViewViewModel(storage: storage, repository: repository)
        let view = MainView(vm: vm)
        
        vm.textfieldText = "London"
        await vm.addNewButtonPressed()
        
        vm.toolbarEditButtonPressed()
        
        assertSnapshot(of: view, as: .image)
    }
    
    func testMainViewAddedCityEditButtonPressedTwice() async {
        let storage = StorageMock()
        let repository = WeatherRepositoryMock()
        let vm = MainViewViewModel(storage: storage, repository: repository)
        let view = MainView(vm: vm)
        
        vm.textfieldText = "London"
        await vm.addNewButtonPressed()
        
        vm.toolbarEditButtonPressed()
        vm.toolbarEditButtonPressed()
        
        assertSnapshot(of: view, as: .image)
    }
    
    func testMainViewDeleteButtonTapped() async {
        let storage = StorageMock()
        let repository = WeatherRepositoryMock()
        let vm = MainViewViewModel(storage: storage, repository: repository)
        let view = MainView(vm: vm)
        
        vm.textfieldText = "London"
        await vm.addNewButtonPressed()
        
        vm.remove(city: "London")
        
        assertSnapshot(of: view, as: .image)
    }
}
