import SwiftUI

struct EntryListView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var diary: DiaryNote
    
    let pets: [Pet]
    let saveAction: (DiaryNote) -> Void
    
    @State private var selectedPets: [Pet] = []
    @State private var isShowAddView = false

    var body: some View {
        ZStack {
            Image(.Images.bg)
                .aduptImage()
            
            VStack {
                navigation
                
                if pets.isEmpty {
                    stumb
                } else {
                    petsList
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $isShowAddView) {
            AddDiaryView(diary: diary) { diary in
                saveAction(diary)
            }
        }
        .onAppear {
            selectedPets = pets.filter { diary.petIDs.contains($0.id )}
        }
        .onChange(of: selectedPets) { pets in
            diary.petIDs = pets.map { $0.id }
        }
    }
    
    private var navigation: some View {
        ZStack {
            Text("Add pet")
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
                
                Spacer()
                
                if !pets.isEmpty {
                    Button {
                        isShowAddView = true
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 26, weight: .medium))
                            .foregroundStyle(.customRed.opacity(selectedPets.isEmpty ? 0.5 : 1))
                    }
                    .disabled(selectedPets.isEmpty)
                }
            }
        }
        .padding(.top, 30)
        .padding(.horizontal, 35)
    }
    
    private var stumb: some View {
        VStack(spacing: 24) {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text("There are no pets yet")
                        .font(.purse(with: 24))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                }
                
                Image(.Images.Diary.book)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 148, height: 133)
            }
            .padding(.vertical, 31)
            .padding(.horizontal, 27)
            .background(.white)
            .cornerRadius(25)
        }
        .padding(.horizontal, 35)
    }
    
    private var petsList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 8) {
                ForEach(pets) { pet in
                    EntryListPetCellView(pet: pet, selectedPets: $selectedPets)
                }
            }
            .padding(.horizontal, 35)
        }
    }
}

#Preview {
    EntryListView(diary: DiaryNote(isTrue: false), pets: [Pet(isTrue: false)]) { _ in }
}


