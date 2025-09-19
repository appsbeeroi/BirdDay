import SwiftUI

struct PetDetailView: View {
    
    @State var pet: Pet
    
    let saveAction: (Pet) -> Void
    let removeAction: (Pet) -> Void
    
    @State private var isShowEditView = false
    @State private var isLoading = false
    
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
            
            if isLoading {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.customGray.opacity(0.5))
                    .overlay {
                        ProgressView()
                    }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $isShowEditView) {
            AddPetView(pet: pet, isNew: false) { newPet in
                pet = newPet
                isShowEditView = false
            }
        }
    }
    
    private var navigation: some View {
        HStack {
            Button {
                isLoading = true
                saveAction(pet)
            } label: {
                Image(systemName: "arrow.backward")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(.customRed)
            }
            
            HStack(spacing: 8) {
                Button {
                    isShowEditView.toggle()
                } label: {
                    Image(.Images.Icons.edit)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.blue)
                }
                
                Button {
                    removeAction(pet)
                } label: {
                    Image(.Images.Icons.remove)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.red)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
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
         
            archiveButton
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
    
    private var archiveButton: some View {
        HStack {
            Button {
                pet.isArchived.toggle()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: pet.isArchived ? "checkmark.circle.fill" : "arrow.down.to.line.square")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(pet.isArchived ? .green : .blue)
                    
                    Text(pet.isArchived ? "Remove from archived" : "Move to archive")
                        .font(.purse(with: 15))
                        .foregroundStyle(.white)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .background(.customRed)
                .cornerRadius(35)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

#Preview {
    PetDetailView(pet: Pet(isTrue: false)) { _ in } removeAction: { _ in }
}
