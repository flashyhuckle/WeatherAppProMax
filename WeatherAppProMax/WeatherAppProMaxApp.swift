import SwiftUI
import SwiftData

@main
struct WeatherAppProMaxApp: App {
    
//    let modelContainer: ModelContainer
//    
//    init() {
//        do {
//            modelContainer = try ModelContainer(for: Weather.self)
//        } catch {
//            fatalError("error creating model container")
//        }
//    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
