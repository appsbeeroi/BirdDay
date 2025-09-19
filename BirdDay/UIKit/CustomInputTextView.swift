import SwiftUI

struct CustomInputTextView: View {
    
    let placeholder: String
    
    @Binding var text: String
    
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        HStack {
            TextField("", text: $text, prompt: Text(placeholder)
                .foregroundColor(.customGray))
            .foregroundStyle(.black)
            .font(.purse(with: 20))
            
            if text != "" {
                Button {
                    
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.customGray.opacity(0.5))
                }
            }
        }
        .frame(height: 60)
        .padding(.horizontal, 12)
        .background(.white)
        .cornerRadius(27)
    }
}

