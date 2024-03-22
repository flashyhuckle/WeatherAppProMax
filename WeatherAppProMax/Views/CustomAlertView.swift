import SwiftUI

struct CustomAlertView: View {
    @Binding private var isPresented: Bool
    @Binding private var textfieldText: String
    @State private var titleKey: LocalizedStringKey
    @State private var actionTextKey: LocalizedStringKey
    
    @FocusState private var textfieldFocused: Bool
    
    @State private var isAnimating = false
    private let animationDuration = 0.25

    private var action: (() -> ())?
    private var cancelAction: (() -> ())?
    
    init(
        titleKey: LocalizedStringKey,
        isPresented: Binding<Bool>,
        textfieldText: Binding<String>,
        actionTextKey: LocalizedStringKey,
        action: @escaping () -> (),
        cancelAction: @escaping () -> ()
    ) {
        _titleKey = State(wrappedValue: titleKey)
        _actionTextKey = State(wrappedValue: actionTextKey)
        _isPresented = isPresented
        _textfieldText = textfieldText
        
        self.action = action
        self.cancelAction = cancelAction
    }
    
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(isPresented ? 0.6 : 0)
                .zIndex(1)
            
            if isAnimating {
                VStack {
                    Text(titleKey)
                        .font(.title2).bold()
                        .foregroundStyle(.tint)
                        .padding(8)
                    TextField("City name", text: $textfieldText)
                        .multilineTextAlignment(.center)
                        .focused($textfieldFocused)
                        .submitLabel(.search)
                        .onSubmit {
                            dismiss()
                            action?()
                        }
                    
                    HStack {
                        CancelButton
                        DoneButton
                    }
                    .padding()
                }
                .padding()
                .frame(maxWidth: 250)
                .background(.background)
                .cornerRadius(35)
                .transition(.opacity)
                .zIndex(2)
                .offset(y: -100)
            }
                
        }
        .ignoresSafeArea()
        .onAppear {
            show()
            textfieldFocused = true
        }
    }
    
    var DoneButton: some View {
        Button {
            dismiss()
            action?()
        } label: {
            Text(actionTextKey)
                .font(.headline).bold()
                .foregroundStyle(Color.white)
                .padding()
                .multilineTextAlignment(.center)
                .frame(maxWidth: 125)
                .background(.tint)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
    
    var CancelButton: some View {
        Button {
            dismiss()
            cancelAction?()
            
        } label: {
            Text("Cancel")
                .font(.headline)
                .foregroundStyle(.tint)
                .padding()
                .lineLimit(1)
                .frame(maxWidth: 125)
                .background(Material.regular)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }

    func dismiss() {
        if #available(iOS 17.0, *) {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isAnimating = false
            } completion: {
                isPresented = false
            }
        } else {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isAnimating = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                isPresented = false
            }
        }
    }

    func show() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            isAnimating = true
        }
    }
}

extension View {
    func customAlert(
        _ titleKey: LocalizedStringKey,
        isPresented: Binding<Bool>,
        textfieldText: Binding<String>,
        actionText: LocalizedStringKey,
        action: @escaping () -> (),
        cancelAction: @escaping () -> ()
    ) -> some View {
        fullScreenCover(isPresented: isPresented) {
            CustomAlertView(
                titleKey: titleKey,
                isPresented: isPresented,
                textfieldText: textfieldText,
                actionTextKey: actionText,
                action: action,
                cancelAction: cancelAction
            )
            .presentationBackground(.clear)
        }
        .transaction { transaction in
            if isPresented.wrappedValue {
                transaction.disablesAnimations = true
            }
        }
    }
}
