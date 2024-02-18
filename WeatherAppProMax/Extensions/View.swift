import SwiftUI

struct OpacityFont: ViewModifier {
    let size: CGFloat
    let opacity: Double
    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
            .opacity(opacity)
    }
}

extension View {
    func opacityFont(size: CGFloat, opacity: Double = 1) -> some View {
        modifier(OpacityFont(size: size, opacity: opacity))
    }
}

struct CustomColor: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color)
    }
}

struct CustomTint: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .tint(color)
    }
}

extension View {
    func customPrimaryColor() -> some View {
        modifier(CustomColor(color: .white))
    }
}

extension View {
    func customSecondaryColor() -> some View {
        modifier(CustomColor(color: .teal))
    }
}

extension View {
    func customPrimaryTint() -> some View {
        modifier(CustomTint(color: .white))
    }
}
