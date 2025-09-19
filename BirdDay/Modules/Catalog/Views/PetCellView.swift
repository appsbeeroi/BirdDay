import SwiftUI

struct PetCellView: View {
    
    let pet: Pet
    let isDisable: Bool
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
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
                
                if !isDisable {
                    Image(systemName: "chevron.forward")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.customRed)
                }
            }
            .frame(height: 90)
            .padding(.horizontal, 13)
            .background(.white)
            .cornerRadius(36)
        }
    }
}
