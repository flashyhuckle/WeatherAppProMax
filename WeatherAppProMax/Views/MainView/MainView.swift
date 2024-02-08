import SwiftUI

struct MainView: View {
    @State private var cityToAdd = ""
    @State private var showingAddAlert = false
    @State private var deletingCities = false
    
    @StateObject var vm: MainViewViewModel
    
    init(
        vm: MainViewViewModel = MainViewViewModel()
    ) {
        _vm = StateObject(wrappedValue: vm)
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if vm.weathers.isEmpty {
                    Text("Add a city with the plus button.")
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(vm.weathers, id: \.self) { weather in
                            ZStack {
                                MainViewTile(
                                    weather: weather.currentWeather,
                                    vm: vm
                                )
                                .padding()
                                if deletingCities {
                                    DeleteCityTileButton(cityName: weather.cityName,
                                                         count: vm.weathers.count,
                                                         deleteMethod: vm.remove(city:),
                                                         isDeleteEnabled: $deletingCities
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToolbarAddButton(isAddingEnabled: $showingAddAlert)
                }
                
                if !vm.weathers.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        ToolbarDeleteButton(isDeleteEnabled: $deletingCities)
                    }
                }
            }
            .alert("Add a city", isPresented: $showingAddAlert, actions: {
                TextField("City name", text: $cityToAdd)
                Button("Add") {
                    withAnimation {
                        vm.refreshWeather(for: cityToAdd)
                        cityToAdd = ""
                    }
                }
                Button("Cancel", role: .cancel) {
                    cityToAdd = ""
                }
            })
            .refreshable {
                vm.forceRefreshAllWeathers()
            }
        }
    }
}
