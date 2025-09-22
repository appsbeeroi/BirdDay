import UserNotifications
import UIKit

enum PermissionStatus {
    case authorized
    case denied
    case notDetermined
}

final class PushPermissionManager {
    
    static let shared = PushPermissionManager()
    
    private init() {}
    
    var status: PermissionStatus {
        get async {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                return .authorized
            case .denied:
                return .denied
            case .notDetermined:
                return .notDetermined
            @unknown default:
                return .denied
            }
        }
    }
    
    @discardableResult
    func requestAccess() async -> Bool {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(
                options: [.alert, .badge, .sound]
            )
            return granted
        } catch {
            print("⚠️ Push permission request failed: \(error.localizedDescription)")
            return false
        }
    }
}
