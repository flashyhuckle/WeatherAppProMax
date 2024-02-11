import SwiftUI

struct MainView: View {
    @State private var cityToAdd = ""
    @State private var showingAddAlert = false
    @State private var isEditEnabled = false
    
    @StateObject var vm: MainViewViewModel
    
    init(
        vm: MainViewViewModel = MainViewViewModel()
    ) {
        _vm = StateObject(wrappedValue: vm)
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if vm.weathers.isEmpty {
                    Text("Add a city with the plus button.")
                } else {
                    MainViewTileView(vm: vm, isEditEnabled: $isEditEnabled)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToolbarAddButton(isAddingEnabled: $showingAddAlert)
                }
                
                if !vm.weathers.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        ToolbarEditButton(isEditEnabled: $isEditEnabled)
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
