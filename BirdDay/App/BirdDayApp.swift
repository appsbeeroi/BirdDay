import SwiftUI

@main
struct BirdDayApp: App {
    
    var body: some Scene {
        WindowGroup {
            AppRouteView()
                .onAppear {
                    Task {
                        await PushPermissionManager.shared.requestAccess()
                    }
                }
        }
    }
}

