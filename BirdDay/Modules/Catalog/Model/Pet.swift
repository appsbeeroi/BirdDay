import UIKit

struct Pet: Identifiable, Equatable {
    let id: UUID
    var image: UIImage?
    var name: String
    var species: String
    var notes: String
    var date: Date
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
        self.date = Date()
    }
    
    init(from ud: PetUD, and image: UIImage) {
        self.id = ud.id
        self.image = image
        self.name = ud.name
        self.species = ud.species
        self.notes = ud.notes
        self.date = ud.date
        self.isArchived = ud.isArchived
    }
}
