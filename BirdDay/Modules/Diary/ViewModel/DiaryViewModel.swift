import SwiftUI

final class DiaryViewModel: ObservableObject {
    
    private let udManager = UDManager.shared
    private let imageManager = LocalImageStore.shared
    
    @Published var isCloseNavigation = false
    @Published private(set) var diaries: [DiaryNote] = []
    
    private(set) var pets: [Pet] = []
    
    func loadDiaries() {
        loadPets()
        
        Task { [weak self] in
            guard let self else { return }
            
            let allDiaries = self.udManager.get([DiaryNoteUD].self, for: .diary) ?? []
            
            let result = await withTaskGroup(of: DiaryNote?.self) { group in
                for diaryUD in allDiaries {
                    group.addTask {
                        guard let image = await self.imageManager.loadImage(named: diaryUD.id.uuidString) else { return nil }
                        let diary = DiaryNote(from: diaryUD, and: image)
                        
                        return diary
                    }
                }
                
                var diaries: [DiaryNote?] = []
                
                for await diary in group {
                    diaries.append(diary)
                }
                
                return diaries.compactMap { $0 }
            }
         
            await MainActor.run {
                self.diaries = result
            }
        }
    }
    
    func save(_ diary: DiaryNote) {
        Task { [weak self] in
            guard let self else { return }
                        
            var allDiaries = self.udManager.get([DiaryNoteUD].self, for: .diary) ?? []
            
            guard let image = diary.image,
                  let imagePath = await self.imageManager.save(image, with: diary.id) else { return }
            
            if let index = allDiaries.firstIndex(where: { $0.id == diary.id }) {
                allDiaries[index] = DiaryNoteUD(from: diary, and: imagePath)
            } else {
                allDiaries.append(DiaryNoteUD(from: diary, and: imagePath))
            }
            
            self.udManager.set(allDiaries, for: .diary)
            
            await MainActor.run {
                if let index = self.diaries.firstIndex(where: { $0.id == diary.id }) {
                    self.diaries[index] = diary
                } else {
                    self.diaries.append(diary)
                }
                
                self.isCloseNavigation = true
            }
        }
    }
    
    func remove(_ diary: DiaryNote) {
        Task { [weak self] in
            guard let self else { return }
            
            var allDiaries = self.udManager.get([DiaryNoteUD].self, for: .diary) ?? []
        
            await imageManager.deleteImage(with: diary.id)
            
            if let index = self.pets.firstIndex(where: { $0.id == diary.id }) {
                allDiaries.remove(at: index)
            }
            
            await MainActor.run {
                if let index = self.diaries.firstIndex(where: { $0.id == diary.id }) {
                    self.diaries.remove(at: index)
                }
                
                self.isCloseNavigation = true
            }
        }
    }
    
    private func loadPets() {
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
}

