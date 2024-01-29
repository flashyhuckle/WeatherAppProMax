import SwiftUI
import SwiftData

@main
struct WeatherAppProMaxApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Weather.self
////            WeatherModel.self
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Weather.self)
        } catch {
            fatalError("error creating model container")
        }
    }

    var body: some Scene {
        WindowGroup {
            MainView(
                vm: MainViewViewModel(context: modelContainer.mainContext)
            )
        }
//        .modelContainer(modelContainer)
    }
}
