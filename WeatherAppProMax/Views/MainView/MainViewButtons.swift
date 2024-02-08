import SwiftUI

struct DeleteCityTileButton: View {
    let cityName: String
    var count: Int
    let deleteMethod: (_ city: String) -> Void
    @Binding var isDeleteEnabled: Bool
    
    var body: some View {
        Button {
            deleteMethod(cityName)
            if count == 1 {
                isDeleteEnabled = false
            }
        } label: {
            Image(systemName: "trash")
                .foregroundStyle(.red)
                .font(.system(size: 50))
                .frame(width: 150, height: 150)
        }
    }
}

struct ToolbarAddButton: View {
    @Binding var isAddingEnabled: Bool
    
    var body: some View {
        Button {
            isAddingEnabled = true
        } label: {
            Image(systemName: "plus")
        }.tint(.teal)
    }
}

struct ToolbarDeleteButton: View {
    @Binding var isDeleteEnabled: Bool
    
    var body: some View {
        Button {
            isDeleteEnabled.toggle()
        } label: {
            if isDeleteEnabled {
                Text("Done")
            } else {
                Text("Edit")
            }
        }.tint(.teal)
    }
}
