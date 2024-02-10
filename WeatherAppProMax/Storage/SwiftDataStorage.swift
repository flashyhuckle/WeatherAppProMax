import Foundation
import SwiftData

class SwiftDataStorage {
    var context: ModelContext?
    
    init<T: PersistentModel>(
        model: T.Type
    ) {
        do {
            let container = try ModelContainer(for: T.self)
            self.context = ModelContext(container)
        } catch {
            assertionFailure(WeatherAppError.DataStorageError.modelContainerNotInitialized.localizedDescription)
        }
    }
    
    private func save() throws {
        do {
            try context?.save()
        } catch {
            throw WeatherAppError.DataStorageError.saveError
        }
    }
    
    private func loadData<T: PersistentModel>() throws -> [T] {
        
        do {
            let descriptor = FetchDescriptor<T>()
            let data = try context?.fetch(descriptor) ?? []
            return data
        } catch {
            throw WeatherAppError.DataStorageError.loadError
        }
    }
    
    private func insertModel<T: PersistentModel>(_ model: T) {
        context?.insert(model)
    }
    
    private func removeModelWithPrecidate<T: PersistentModel>(_ model: T.Type, predicate: Predicate<T>) throws {
        do {
            try context?.delete(model: T.self, where: predicate)
        } catch {
            throw WeatherAppError.DataStorageError.deleteError
        }
    }
    
    private func removeAllModels<T: PersistentModel>(_ model: T.Type) throws {
        do {
            try context?.delete(model: T.self)
        } catch {
            throw WeatherAppError.DataStorageError.deleteError
        }
    }
}

extension SwiftDataStorage: StorageType {
    func loadObjects() -> [Weather] {
        do {
            let data = (try loadData() as [Weather])
                .sorted { $0.cityName < $1.cityName }
            return data
        } catch {
            assertionFailure("Load objects error: \(error)")
            return []
        }
    }
    
    func saveObject(_ object: Weather) {
        insertModel(object)
    }
    
    func removeObject(for key: String) {
        do {
            let predicate = #Predicate<Weather> { weather in
                weather.cityName == key
            }
            try removeModelWithPrecidate(Weather.self, predicate: predicate)
        } catch {
            assertionFailure("No Model to remove for key: \(key)")
        }
    }
    
    func removeAllData() {
        do {
            try removeAllModels(Weather.self)
        } catch {
            assertionFailure("Error removing all data: \(error)")
        }
    }
}
