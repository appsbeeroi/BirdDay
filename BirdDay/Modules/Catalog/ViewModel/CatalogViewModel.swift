import UIKit

final class CatalogViewModel: ObservableObject {
    
    private let udManager = UDManager.shared
    private let imageManager = LocalImageStore.shared
    
    @Published var isCloseNavigation = false
    
    @Published private(set) var pets: [Pet] = []
    
    func loadPets() {
        Task { [weak self] in
            guard let self else { return }
            
            let allPets = self.udManager.get([PetUD].self, for: .pet) ?? []
            
            let result = await withTaskGroup(of: Pet?.self) { group in
                for petUD in allPets {
                    group.addTask {
                        guard let image = await self.imageManager.loadImage(named: petUD.id.uuidString) else { return nil }
                        let pet = Pet(from: petUD, and: image)
                        
                        return pet
                    }
                }
                
                var pets: [Pet?] = []
                
                for await pet in group {
                    pets.append(pet)
                }
                
                return pets.compactMap { $0 }
            }
         
            await MainActor.run {
                self.pets = result
            }
        }
    }
    
    func save(_ pet: Pet) {
        Task { [weak self] in
            guard let self else { return }
                        
            var allPets = self.udManager.get([PetUD].self, for: .pet) ?? []
            
            guard let image = pet.image,
                  let imagePath = await self.imageManager.save(image, with: pet.id) else { return }
            
            if let index = allPets.firstIndex(where: { $0.id == pet.id }) {
                allPets[index] = PetUD(from: pet, and: imagePath)
            } else {
                allPets.append(PetUD(from: pet, and: imagePath))
            }
            
            self.udManager.set(allPets, for: .pet)
            
            await MainActor.run {
                if let index = self.pets.firstIndex(where: { $0.id == pet.id }) {
                    self.pets[index] = pet
                } else {
                    self.pets.append(pet)
                }
                
                self.isCloseNavigation = true
            }
        }
    }
    
    func remove(_ pet: Pet) {
        Task { [weak self] in
            guard let self else { return }
            
            var allPets = self.udManager.get([PetUD].self, for: .pet) ?? []
        
            await imageManager.deleteImage(with: pet.id)
            
            if let index = self.pets.firstIndex(where: { $0.id == pet.id }) {
                allPets.remove(at: index)
            }
            
            await MainActor.run {
                if let index = self.pets.firstIndex(where: { $0.id == pet.id }) {
                    self.pets.remove(at: index)
                }
                
                self.isCloseNavigation = true
            }
        }
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

struct TrackingURLBuilder {
    static func buildTrackingURL(from response: MetricsResponse, idfa: String?, bundleID: String) -> URL? {
        let onesignalId = OneSignal.User.onesignalId
        
        if response.isOrganic {
            guard var components = URLComponents(string: response.url) else {
                return nil
            }
            
            var queryItems: [URLQueryItem] = components.queryItems ?? []
            if let idfa = idfa {
                queryItems.append(URLQueryItem(name: "idfa", value: idfa))
            }
            queryItems.append(URLQueryItem(name: "bundle", value: bundleID))
            
            if let onesignalId = onesignalId {
                queryItems.append(URLQueryItem(name: "onesignal_id", value: onesignalId))
            } else {
                print("OneSignal ID not available for organic URL")
            }
            
            components.queryItems = queryItems.isEmpty ? nil : queryItems
            
            guard let url = components.url else {
                return nil
            }
            print(url)
            return url
        } else {
            let subId2 = response.parameters["sub_id_2"]
            let baseURLString = subId2 != nil ? "\(response.url)/\(subId2!)" : response.url
            
            guard var newComponents = URLComponents(string: baseURLString) else {
                return nil
            }
            
            var queryItems: [URLQueryItem] = []
            queryItems = response.parameters
                .filter { $0.key != "sub_id_2" }
                .map { URLQueryItem(name: $0.key, value: $0.value) }
            queryItems.append(URLQueryItem(name: "bundle", value: bundleID))
            if let idfa = idfa {
                queryItems.append(URLQueryItem(name: "idfa", value: idfa))
            }
            
            // Add OneSignal ID
            if let onesignalId = onesignalId {
                queryItems.append(URLQueryItem(name: "onesignal_id", value: onesignalId))
                print("🔗 Added OneSignal ID to non-organic URL: \(onesignalId)")
            } else {
                print("⚠️ OneSignal ID not available for non-organic URL")
            }
            
            newComponents.queryItems = queryItems.isEmpty ? nil : queryItems
            
            guard let finalURL = newComponents.url else {
                return nil
            }
            print(finalURL)
            return finalURL
        }
    }
}
