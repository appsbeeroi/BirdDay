import SwiftUI

struct SplashScreen: View {
    
    @Binding var isOn: Bool
    
    var body: some View {
        ZStack {
            Image(.Images.launch)
                .aduptImage()
            
            VStack(spacing: 10) {
                StrokeText("BirdDay", fontSize: 64)
                
                ProgressView()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 120)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isOn = true 
            }
        }
    }
}

#Preview {
    SplashScreen(isOn: .constant(false))
}
