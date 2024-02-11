import SwiftUI

struct MainViewTileView: View {
    @StateObject var vm: MainViewViewModel
    @Binding var isEditEnabled: Bool
    
    var body: some View {
        LazyVGrid(columns: getColumns()) {
            ForEach(vm.weathers, id: \.self) { weather in
                ZStack {
                    MainViewTile(
                        weather: weather.currentWeather,
                        vm: vm
                    )
                    .padding()
                    if isEditEnabled {
                        DeleteCityTileButton(cityName: weather.cityName,
                                             count: vm.weathers.count,
                                             deleteMethod: vm.remove(city:),
                                             isDeleteEnabled: $isEditEnabled
                        )
                    }
                }
            }
        }
        .padding()
    }
    
    private func getColumns() -> [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            [GridItem(.flexible(), spacing: 20),GridItem(.flexible(), spacing: 20),GridItem(.flexible(), spacing: 20),GridItem(.flexible(), spacing: 20)]
        } else {
            [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]
        }
    }
}
