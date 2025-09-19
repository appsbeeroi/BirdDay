import SwiftUI

struct CalendarPetDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var pet: Pet
    
    var body: some View {
        ZStack {
            Image(.Images.bg)
                .aduptImage()
            
            VStack(spacing: 16) {
                navigation
                
                VStack(spacing: 16) {
                    image
                    petInfo
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 35)
        }
        .navigationBarBackButtonHidden()
    }
    
    private var navigation: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.backward")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(.customRed)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 30)
    }
    
    private var image: some View {
        Image(uiImage: pet.image ?? UIImage())
            .resizable()
            .scaledToFill()
            .frame(width: 250, height: 250)
            .clipped()
            .cornerRadius(130)
    }
    
    private var petInfo: some View {
        VStack(spacing: 8) {
            VStack(spacing: 14) {
                status
                name
                
                Divider()
                
                birthDate
                
                Divider()
                
                species
                notes
            }
            .padding(16)
            .background(.white)
            .cornerRadius(25)
        }
    }
    
    private var status: some View {
        HStack(spacing: 2) {
            Image(systemName: pet.isArchived ? "arrow.down.to.line.square" : "checkmark.circle.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(pet.isArchived ? .blue : .green)
            
            Text(pet.isArchived ? "in the archive" : "active pet")
                .font(.purse(with: 13))
                .foregroundStyle(.black)
        }
        .frame(height: 30)
        .padding(.horizontal, 6)
        .cornerRadius(28)
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .stroke(.black, lineWidth: 1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var name: some View {
        Text(pet.name)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.purse(with: 35))
            .foregroundStyle(.black)
    }
    
    private var birthDate: some View {
        HStack(spacing: 4) {
            Image(.Images.Icons.calendar)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            
            Text(pet.date.formatted(.dateTime.year().month(.twoDigits).day()))
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.purse(with: 16))
                .foregroundStyle(.black)
        }
    }
    
    private var species: some View {
        HStack {
            Text("Species")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.purse(with: 15))
                .foregroundStyle(.customGray)
            
            Text(pet.species)
                .font(.purse(with: 20))
                .foregroundStyle(.black)
        }
    }
    
    private var notes: some View {
        VStack(spacing: 4) {
            Text("Notes")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.purse(with: 15))
                .foregroundStyle(.customGray)
            
            Text(pet.notes)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.purse(with: 20))
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    CalendarPetDetailView(pet: Pet(isTrue: false))
}
