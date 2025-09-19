import SwiftUI

struct AppRouteView: View {
    
    @State private var isOn = false
    
    var body: some View {
        if isOn {
            MainTabView()
        } else {
            SplashScreen(isOn: $isOn)
        }
    }
}

#Preview {
    AppRouteView()
}
