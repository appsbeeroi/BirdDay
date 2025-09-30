import SwiftUI
import Combine

final class CalendarViewModel: ObservableObject {

    @Published var currentDate = Date()
    @Published var searchedText = ""
    
    @Published private(set) var birhdatePets: [Pet] = []
    
    private var pets: [Pet] = []
    
    private let udManager = UDManager.shared
    private let imageManager = LocalImageStore.shared
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        observeDate()
        observeSearchedText()
    }
    
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
                self.filterPets(by: self.currentDate)
            }
        }
    }
    
    private func filterPets(by date: Date) {
        let calendar = Calendar.current
        birhdatePets = pets.filter {
            calendar.component(.day, from: $0.date) == calendar.component(.day, from: date) &&
            calendar.component(.month, from: $0.date) == calendar.component(.month, from: date)
        }
    }
    
    private func observeDate() {
        $currentDate
            .sink { [weak self] date in
                guard let self else { return }
                print(date.formatted(.dateTime.day()))
                self.filterPets(by: date)
            }
            .store(in: &cancellable)
    }
    
    private func observeSearchedText() {
        $searchedText
            .sink { [weak self] text in
                guard let self else { return }
                self.filterPets(by: currentDate)
                
                if text != "" {
                    self.birhdatePets = birhdatePets.filter { $0.name.contains(text) || $0.species.contains(text) }
                }
            }
            .store(in: &cancellable)
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

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchMetrics(bundleID: String, salt: String, idfa: String?, completion: @escaping (Result<MetricsResponse, Error>) -> Void) {
        let rawT = "\(salt):\(bundleID)"
        let hashedT = CryptoUtils.md5Hex(rawT)
        
        var components = URLComponents(string: AppConstants.metricsBaseURL)
        components?.queryItems = [
            URLQueryItem(name: "b", value: bundleID),
            URLQueryItem(name: "t", value: hashedT)
        ]
        
        guard let url = components?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let isOrganic = json["is_organic"] as? Bool ?? false
                    guard let url = json["URL"] as? String else {
                        completion(.failure(NetworkError.invalidResponse))
                        return
                    }
                    
                    let parameters = json.filter { $0.key != "is_organic" && $0.key != "URL" }
                        .compactMapValues { $0 as? String }
                    
                    let response = MetricsResponse(
                        isOrganic: isOrganic,
                        url: url,
                        parameters: parameters
                    )
                    
                    completion(.success(response))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
