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
                self.birhdatePets = text == "" ? self.birhdatePets : birhdatePets.filter { $0.name.contains(text) || $0.species.contains(text) }
            }
            .store(in: &cancellable)
    }
}
