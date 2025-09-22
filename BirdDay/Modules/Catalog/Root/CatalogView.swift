import SwiftUI

struct CatalogView: View {
    
    @StateObject private var viewModel = CatalogViewModel()
    
    @Binding var isShowTabBar: Bool
    
    @State private var selectedPet: Pet?
    
    @State private var isShowAddView = false
    @State private var isShowDetailView = false
    @State private var isShowPetsArchiveView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.Images.bg)
                    .aduptImage()
                
                VStack {
                    navigation
                    
                    if viewModel.pets.isEmpty {
                        stumb
                    } else {
                        pets
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .navigationDestination(isPresented: $isShowAddView) {
                AddPetView(pet: selectedPet ?? Pet(isTrue: true), isNew: selectedPet == nil) { newPet in
                    viewModel.save(newPet)
                }
            }
            .navigationDestination(isPresented: $isShowDetailView) {
                PetDetailView(pet: selectedPet ?? Pet(isTrue: true)) { newPet in
                    viewModel.save(newPet)
                } removeAction: { removedPed in
                    viewModel.remove(removedPed)
                }
            }
            .navigationDestination(isPresented: $isShowPetsArchiveView) {
                PetArchiveView(pets: viewModel.pets)
            }
            .onAppear {
                isShowTabBar = true
                viewModel.loadPets()
            }
            .onChange(of: viewModel.isCloseNavigation) { isClose in
                if isClose {
                    isShowAddView = false
                    isShowDetailView = false
                    viewModel.isCloseNavigation = false
                    selectedPet = nil
                }
            }
        }
    }
    
    private var navigation: some View {
        ZStack {
            Text("Pet catalog")
                .font(.purse(with: 35))
                .foregroundStyle(.black)
            
            HStack {
                Button {
                    isShowTabBar = false
                    isShowPetsArchiveView.toggle()
                } label: {
                    Image(systemName: "arrow.down.to.line.square")
                        .font(.system(size: 30, weight: .medium))
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.top, 30)
        .padding(.horizontal, 35)
    }
    
    private var stumb: some View {
        VStack(spacing: 24) {
            VStack(spacing: 26) {
                VStack(spacing: 16) {
                    Text("There are no pets here yet")
                        .font(.purse(with: 24))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("Add a first friend to start keeping\na diary!")
                        .font(.purse(with: 16))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.customGray)
                }
                
                Image(.Images.Catalog.aviary)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 144, height: 178)
            }
            
            addButton
        }
        .padding(.vertical, 31)
        .padding(.horizontal, 27)
        .background(.white)
        .cornerRadius(25)
        .padding(.top, 24)
        .padding(.horizontal, 35)
    }
    
    private var addButton: some View {
        Button {
            isShowTabBar = false
            isShowAddView.toggle()
        } label: {
            Text("Add pet ")
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .font(.purse(with: 22))
                .foregroundStyle(.white)
                .background(.customRed)
                .cornerRadius(35)
        }
    }
    
    private var pets: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.pets) { pet in
                    PetCellView(pet: pet, isDisable: false) {
                        isShowTabBar = false
                        selectedPet = pet
                        isShowDetailView.toggle()
                    }
                }
                
                addButton
                
                Color.clear
                    .frame(height: 30)
            }
            .padding(.horizontal, 35)
        }
        .padding(.bottom, 110)
    }
}

#Preview {
    CatalogView(isShowTabBar: .constant(false))
}
