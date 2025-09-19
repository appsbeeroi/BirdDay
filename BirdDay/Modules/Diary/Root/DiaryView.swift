import SwiftUI

struct DiaryView: View {
    
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
        Text("Holiday diary")
            .padding(.top, 30)
            .font(.purse(with: 35))
            .foregroundStyle(.black)
    }
}

#Preview {
    DiaryView(isShowTabBar: .constant(false))
}
