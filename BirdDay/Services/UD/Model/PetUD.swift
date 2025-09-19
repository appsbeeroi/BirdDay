import Foundation

struct PetUD: Codable {
    let id: UUID
    var imagePath: String
    var name: String
    var species: String
    var notes: String
    var date: Date
    var diaryNote: String
    var isArchived: Bool
    
    init(from model: Pet, and imagePath: String) {
        self.id = model.id
        self.imagePath = imagePath
        self.name = model.name
        self.species = model.species
        self.notes = model.notes
        self.date = model.date
        self.diaryNote = model.diaryNote
        self.isArchived = model.isArchived
    }
}
