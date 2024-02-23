import SwiftUI

struct MainViewTileView: View {
    @StateObject var vm: MainViewViewModel
    
    var body: some View {
        LazyVGrid(columns: getColumns()) {
            ForEach(vm.weathers, id: \.self) { weather in
                ZStack {
                    MainViewTile(
                        vm: MainViewTileViewModel(weather: weather)
                    )
                    .padding()
                    if vm.isEditEnabled {
                        DeleteCityTileButton(cityName: weather.cityName,
                                             deleteMethod: vm.remove(city:),
                                             isDeleteEnabled: $vm.isEditEnabled
                        )
                    }
                }
            }
            
        }
        .padding()
    }
    
    private func getColumns() -> [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            [GridItem(.flexible(), spacing: .small),
             GridItem(.flexible(), spacing: .small),
             GridItem(.flexible(), spacing: .small),
             GridItem(.flexible(), spacing: .small)]
        } else {
            [GridItem(.flexible(), spacing: .small),
             GridItem(.flexible(), spacing: .small)]
        }
    }
}
