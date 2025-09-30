import SwiftUI

struct SplashScreen: View {
    
    @Binding var isOn: Bool
    
    var body: some View {
        ZStack {
            Image(.Images.launch)
                .aduptImage()
            
            VStack(spacing: 10) {
                StrokeText("Bird Day\nDiary", fontSize: 64)
                
                ProgressView()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 120)
        }
        .onReceive(NotificationCenter.default.publisher(for: .splashTransition)) { _ in
            withAnimation {
                isOn = true
            }
        }
    }
}

#Preview {
    SplashScreen(isOn: .constant(false))
}
