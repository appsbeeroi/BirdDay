import SwiftUI

struct SettingsView: View {
    
    @Binding var isShowTabBar: Bool
    
    var body: some View {
        ZStack {
            Image(.Images.bg)
                .aduptImage()
            
            VStack {
                navigation
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    private var navigation: some View {
        Text("Settings")
            .padding(.top, 30)
            .font(.purse(with: 35))
            .foregroundStyle(.black)
    }
}

#Preview {
    SettingsView(isShowTabBar: .constant(false))
}
