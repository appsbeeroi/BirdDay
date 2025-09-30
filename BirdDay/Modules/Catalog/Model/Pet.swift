import UIKit

struct Pet: Identifiable, Equatable {
    let id: UUID
    var image: UIImage?
    var name: String
    var species: String
    var notes: String
    var date: Date
    var diaryNote: String
    var isArchived = false
    
    var isClose: Bool {
        image == nil || name == "" || species == "" || notes == ""
    }
    
    init(isTrue: Bool) {
        self.id = UUID()
        self.name = isTrue ? "" : "Fluffykins"
        self.species = isTrue ? "" : "Dog"
        self.notes = isTrue ? "" : "Loves to cuddle."
        self.isArchived = isTrue ? false : true
        self.diaryNote = isTrue ? "" : "Today was a good day!"
        self.date = Date()
    }
    
    init(from ud: PetUD, and image: UIImage) {
        self.id = ud.id
        self.image = image
        self.name = ud.name
        self.species = ud.species
        self.notes = ud.notes
        self.date = ud.date
        self.diaryNote = ud.diaryNote
        self.isArchived = ud.isArchived
    }
}

import SwiftUI
import SwiftUI
import CryptoKit
import WebKit
import AppTrackingTransparency
import UIKit
import FirebaseCore
import FirebaseRemoteConfig
import OneSignalFramework
import AdSupport


class ConfigManager {
    static let shared = ConfigManager()
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    private let defaults: [String: NSObject] = [AppConstants.remoteConfigKey: true as NSNumber]
    
    private init() {
        remoteConfig.setDefaults(defaults)
    }
    
    func fetchConfig(completion: @escaping (Bool) -> Void) {
        if let savedState = UserDefaults.standard.object(forKey: AppConstants.remoteConfigStateKey) as? Bool {
            completion(savedState)
            return
        }
        
        remoteConfig.fetch(withExpirationDuration: 0) { status, error in
            if status == .success {
                self.remoteConfig.activate { _, _ in
                    let isEnabled = self.remoteConfig.configValue(forKey: AppConstants.remoteConfigKey).boolValue
                    UserDefaults.standard.set(isEnabled, forKey: AppConstants.remoteConfigStateKey)
                    completion(isEnabled)
                }
            } else {
                UserDefaults.standard.set(true, forKey: AppConstants.remoteConfigStateKey)
                completion(true)
            }
        }
    }
    
    func getSavedURL() -> URL? {
        guard let urlString = UserDefaults.standard.string(forKey: AppConstants.userDefaultsKey),
              let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    func saveURL(_ url: URL) {
        UserDefaults.standard.set(url.absoluteString, forKey: AppConstants.userDefaultsKey)
    }
}
