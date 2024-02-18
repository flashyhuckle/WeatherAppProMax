import XCTest
@testable import WeatherAppProMax

final class SwiftDataStorageTests: XCTestCase {
    private let storage: any StorageType<Weather> = SwiftDataStorage(model: Weather.self)
    
    func testSwiftDataRemoveAll() {
        //clearing from previous test
        storage.removeAllObjects()
        
        //we shouldn't get any objects
        let loadedObjects = storage.loadObjects()
        XCTAssertNotNil(loadedObjects)
        XCTAssertEqual(loadedObjects.count, 0)
    }
    
    func testSwiftDataSaveAndLoad() {
        //clearing from previous test
        storage.removeAllObjects()
        
        //creating sample model
        let weather = Weather(
            cityName: WeatherModel.example.cityName,
            country: WeatherModel.example.country,
            timezone: WeatherModel.example.timezone
        )
        
        //saving sample model
        storage.saveObject(weather)
        
        //testing if objects get loaded
        let loadedObjects = storage.loadObjects()
        XCTAssertNotNil(loadedObjects)
        XCTAssertEqual(loadedObjects.count, 1)
        
        //testing if we got sample model object
        let first = loadedObjects.first
        XCTAssertNotNil(first)
        XCTAssertEqual(first, weather)
        
        //saving the same object shouldn't duplicate it
        storage.saveObject(weather)
        
        let reloadedObjects = storage.loadObjects()
        XCTAssertEqual(reloadedObjects.count, 1)
    }
}
