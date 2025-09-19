import UIKit

struct DiaryNote: Identifiable, Equatable {
    let id: UUID
    var image: UIImage?
    var petIDs: [UUID] = []
    var date: Date
    var note: String
    
    var isClose: Bool {
        image == nil || note == ""
    }
    
    init(isTrue: Bool) {
        self.id = UUID()
        self.date = Date()
        self.note = isTrue ? "" : "🐰🐹🐻"
    }
    
    init(from ud: DiaryNoteUD, and image: UIImage) {
        self.id = ud.id
        self.image = image
        self.petIDs = ud.petIDs
        self.date = ud.date
        self.note = ud.note
    }
}
