import SwiftUI

@main
struct BirdDayApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            BlackWindow(rootView: AppRouteView(), remoteConfigKey: AppConstants.remoteConfigKey)
        }
    }
}

struct AppConstants {
    static let metricsBaseURL = "https://ddirdbay.com/app/metrics"
    static let salt = "kzitw7mOx5VsTVD5ie2QSupeGM2RCsCA"
    static let oneSignalAppID = "69711e19-e8aa-421e-aa56-795a2aa125a6"
    static let userDefaultsKey = "bird"
    static let remoteConfigStateKey = "birdDay"
    static let remoteConfigKey = "isBirdDayEnable"
}

