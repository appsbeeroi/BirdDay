import SwiftUI

struct EntryListPetCellView: View {
    
    let pet: Pet
    
    @Binding var selectedPets: [Pet]
        
    var body: some View {
        Button {
            if let index = selectedPets.firstIndex(where: { $0.id == pet.id }) {
                selectedPets.remove(at: index)
            } else {
                selectedPets.append(pet)
            }
        } label: {
            HStack(spacing: 8) {
                Image(uiImage: pet.image ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 66, height: 66)
                    .clipped()
                    .cornerRadius(130)
                
                VStack(spacing: 8) {
                    VStack(spacing: 0) {
                        Text(pet.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.purse(with: 20))
                            .foregroundStyle(.black)
                        
                        Text(pet.species)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.purse(with: 11))
                            .foregroundStyle(.customGray)
                    }
                    
                    HStack(spacing: 4) {
                        Image(.Images.Icons.calendar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                        
                        Text(pet.date.formatted(.dateTime.year().month(.twoDigits).day()))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.purse(with: 11))
                            .foregroundStyle(.customGray)
                    }
                }
                
                Circle()
                    .stroke(.customRed, lineWidth: 1)
                    .frame(width: 25, height: 25)
                    .overlay {
                        if selectedPets.contains(pet) {
                            Circle()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.customRed)
                        }
                    }
            }
            .frame(height: 90)
            .padding(.horizontal, 13)
            .background(.white)
            .cornerRadius(36)
        }
    }
}

