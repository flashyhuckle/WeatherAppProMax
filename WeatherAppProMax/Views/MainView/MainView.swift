import SwiftUI

struct MainView: View {
    @StateObject var vm: MainViewViewModel
    
    init(
        vm: MainViewViewModel
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
                    MainViewTileView(vm: vm)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToolbarAddButton(isAddingEnabled: $vm.addAlertShowing, isEditEnabled: $vm.isEditEnabled)
                }
                
                if !vm.weathers.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        ToolbarEditButton(isEditEnabled: $vm.isEditEnabled)
                    }
                }
            }
            .customAlert("Add a city", isPresented: $vm.addAlertShowing, textfieldText: $vm.textfieldText, actionText: "Add", action: {
                Task {
                    await vm.addNewButtonPressed()
                }
            }, cancelAction: {
                vm.cancelButtonPressed()
            })
            .refreshable {
                await vm.refresh()
            }
            .onAppear {
                Task {
                    await vm.onAppear()
                }
            }
        }
    }
}
