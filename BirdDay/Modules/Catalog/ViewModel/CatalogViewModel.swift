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
