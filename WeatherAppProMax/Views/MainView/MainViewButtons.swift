import SwiftUI

struct DeleteCityTileButton: View {
    let cityName: String
    let deleteMethod: (_ city: String) -> Void
    @Binding var isDeleteEnabled: Bool
    
    var body: some View {
        Button {
            deleteMethod(cityName)
        } label: {
            Image(systemName: "trash")
                .foregroundStyle(.red)
                .opacityFont(size: .large)
                .frame(width: .xlarge * 2, height: .xlarge * 2)
        }
    }
}

struct ToolbarAddButton: View {
    @Binding var isAddingEnabled: Bool
    @Binding var isEditEnabled: Bool
    
    var body: some View {
        Button {
            isAddingEnabled = true
            isEditEnabled = false
        } label: {
            Image(systemName: "plus")
        }
        .customSecondaryColor()
    }
}

struct ToolbarEditButton: View {
    @Binding var isEditEnabled: Bool
    
    var body: some View {
        Button {
            withAnimation {
                isEditEnabled.toggle()
            }
        } label: {
            if isEditEnabled {
                Text("Done")
            } else {
                Text("Edit")
            }
        }
        .customSecondaryColor()
    }
}
