@testable import WeatherAppProMax

final class StorageMock: StorageType {
    
    private var objects = [Weather]()
    
    func loadObjects() -> [WeatherAppProMax.Weather] {
        return objects
    }
    
    func saveObject(_ object: WeatherAppProMax.Weather) {
        objects.append(object)
    }
    
    func removeObject(for key: String) {
        objects.removeAll { object in
            object.cityName == key
        }
    }
    
    func removeAllObjects() {
        objects = []
    }
}
