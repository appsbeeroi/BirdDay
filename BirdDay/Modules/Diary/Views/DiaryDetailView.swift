import SwiftUI

struct DiaryDetailView: View {
    
    @State var diary: DiaryNote
    
    let pets: [Pet]
    
    let saveAction: (DiaryNote) -> Void
    let removeAction: (DiaryNote) -> Void
    
    @State private var isShowEditView = false
    @State private var isLoading = false
    
    var filteredPets: [Pet] {
        pets.filter { diary.petIDs.contains($0.id) }
    }

    var body: some View {
        ZStack {
            Image(.Images.bg)
                .aduptImage()
            
            VStack(spacing: 16) {
                navigation
                
                VStack(spacing: 16) {
                    image
                    petsList
                    notes
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
            AddDiaryView(diary: diary) { newDiary in
                diary = newDiary
                saveAction(diary)
            }
        }
    }
    
    private var navigation: some View {
        HStack {
            Button {
                isLoading = true
                saveAction(diary)
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
                    removeAction(diary)
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
        Image(uiImage: diary.image ?? UIImage())
            .resizable()
            .scaledToFill()
            .frame(width: 250, height: 250)
            .clipped()
            .cornerRadius(130)
    }
    
    private var petsList: some View {
        VStack(spacing: 4) {
            Text("Pets")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.purse(with: 20))
                .foregroundStyle(.black)
            
            LazyVStack(spacing: 8) {
                ForEach(filteredPets) { pet in
                    PetCellView(pet: pet, isDisable: true) {}
                        .disabled(true)
                }
            }
        }
    }

    private var notes: some View {
        VStack(spacing: 4) {
            Text("Notes")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.purse(with: 15))
                .foregroundStyle(.customGray)
            
            Text(diary.note)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.purse(with: 20))
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
        }
    }
}

