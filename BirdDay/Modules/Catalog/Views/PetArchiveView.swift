import SwiftUI

struct PetArchiveView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var pets: [Pet]
    
    var archivePets: [Pet] {
        pets.filter { $0.isArchived }
    }
    
    var body: some View {
        ZStack {
            Image(.Images.bg)
                .aduptImage()
            
            VStack {
                navigation
                
                if archivePets.isEmpty {
                    stumb
                } else {
                    petsList
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarBackButtonHidden()
        .animation(.easeInOut, value: pets)
    }
    
    private var navigation: some View {
        ZStack {
            Text("Archive")
                .font(.purse(with: 35))
                .foregroundStyle(.black)
            
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
        }
        .padding(.top, 30)
        .padding(.horizontal, 35)
    }
    
    private var stumb: some View {
        VStack(spacing: 18) {
            Text("You do not have any pets\non file yet")
                .font(.purse(with: 24))
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
            
            Image(.Images.Catalog.aviary)
                .resizable()
                .scaledToFit()
                .frame(width: 144, height: 178)
        }
        .padding(.vertical, 48)
        .padding(.horizontal, 27)
        .background(.white)
        .cornerRadius(25)
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 35)
        .padding(.horizontal, 35)
    }
    
    private var petsList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 8) {
                ForEach(archivePets) { pet in
                    PetCellView(pet: pet, isDisable: true) {}
                        .disabled(true)
                }
            }
            .padding(.horizontal, 35)
        }
    }
}

#Preview {
    PetArchiveView(pets: [Pet(isTrue: true)])
}
