import Foundation

struct DiaryNoteUD: Codable {
    let id: UUID
    let imagePath: String
    let petIDs: [UUID]
    var date: Date
    let note: String
    
    init(from model: DiaryNote, and imagePath: String) {
        self.id = model.id
        self.imagePath = imagePath
        self.petIDs = model.petIDs
        self.date = model.date
        self.note = model.note
    }
}
