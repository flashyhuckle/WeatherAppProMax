import SwiftData
import SwiftUI

struct MainView: View {
    
    @State private var cityToAdd = ""
    @State private var showingAddAlert = false
    @State private var deletingCities = false
    
    @StateObject var vm: MainViewViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if vm.weathers.isEmpty {
                    Text("Add a city with the plus button.")
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(vm.weathers, id: \.self) { weather in
                            ZStack {
                                ScrollViewTile(
                                    weather: weather.currentWeather,
                                    vm: vm
                                )
                                .padding()
                                if deletingCities {
                                    Button {
                                        print("delete \(weather.cityName)")
                                        vm.remove(city: weather.cityName)
                                        if vm.weathers.count == 0 {
                                            deletingCities = false
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundStyle(.red)
                                            .font(.system(size: 50))
                                            .frame(width: 150, height: 150)
                                    }

                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }.tint(.red)
                }
                
                if !vm.weathers.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            deletingCities.toggle()
                        } label: {
                            if deletingCities {
                                Text("Done")
                            } else {
                                Image(systemName: "minus")
                            }
                        }.tint(.red)
                    }
                }
            }
            .alert("Add a city", isPresented: $showingAddAlert, actions: {
                TextField("Username", text: $cityToAdd)
                    Button("Add") {
                        withAnimation {
                            vm.refreshWeather(for: cityToAdd)
                            cityToAdd = ""
                        }
                    }
            })
            .refreshable {
                
            }
            .onAppear {
                vm.loadData()
            }
        }
    }
}

struct ScrollViewTile: View {
    let weather: WeatherModel
    
    @StateObject var vm: MainViewViewModel
    
    var body: some View {
        NavigationLink {
            WeatherView(
                city: weather.cityName,
                vm: WeatherViewModel(context: vm.context)
            )
        } label: {
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                    .foregroundStyle(.teal)
                VStack {
                    Text(weather.cityName)
                    HStack {
                        Text(weather.temperatureString)
                        Image(systemName: weather.systemIcon)
                    }
                }
                .foregroundStyle(.white)
            }
            .frame(width: 150, height: 150)
        }
        .onAppear(perform: {
            vm.refreshWeather(for: weather.cityName)
        })
    }
}

//#Preview {
//    MainView(container: ModelContainer(for: WeatherModel.self))
//}
