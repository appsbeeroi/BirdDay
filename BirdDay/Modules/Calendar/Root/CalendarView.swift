import SwiftUI

struct CalendarView: View {
    
    @StateObject private var viewModel = CalendarViewModel()
    
    @Binding var isShowTabBar: Bool
    
    @State private var selectedPet: Pet?
    @State private var isShowDetailView = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.Images.bg)
                    .aduptImage()
                
                VStack {
                    navigation
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 18) {
                            searchInput
                            calendar
                            pets
                        }
                        .padding(.horizontal, 35)
                        
                        Color.clear
                            .frame(height: 30)
                    }
                    .padding(.bottom, 110)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .animation(.easeInOut, value: viewModel.currentDate)
            }
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $isShowDetailView) {
                CalendarPetDetailView(pet: selectedPet ?? Pet(isTrue: true))
            }
            .onAppear {
                isShowTabBar = true
                viewModel.loadPets()
            }
        }
    }
    
    private var navigation: some View {
        Text("Birthday calendar")
            .padding(.top, 30)
            .font(.purse(with: 35))
            .foregroundStyle(.black)
    }
    
    private var searchInput: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.customGray)
            
            TextField("", text: $viewModel.searchedText, prompt: Text("Search")
                .foregroundColor(.customGray))
            .foregroundStyle(.black)
            .font(.purse(with: 20))
            .focused($isFocused)
            
            if viewModel.searchedText != "" {
                Button {
                    viewModel.searchedText = ""
                    isFocused = false 
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.customGray.opacity(0.5))
                }
            }
        }
        .frame(height: 65)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .background(.white)
        .cornerRadius(33)
    }
    
    private var calendar: some View {
        DatePicker("", selection: $viewModel.currentDate, displayedComponents: [.date])
            .labelsHidden()
            .datePickerStyle(.graphical)
            .tint(.customRed)
            .padding()
            .background(.white)
            .cornerRadius(25)
    }
    
    @ViewBuilder
    private var pets: some View {
        if viewModel.birhdatePets.isEmpty {
            VStack(spacing: 16) {
                Image(.Images.Calendar.birdCalendar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 84, height: 79)
                
                Text("Today your pets have\nno birthday")
                    .font(.purse(with: 24))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                
                Text("Relax and get ready for the upcoming holidays!")
                    .font(.purse(with: 16))
                    .foregroundStyle(.customGray)
                    .multilineTextAlignment(.center)
            }
        } else {
            VStack(spacing: 8) {
                Text(viewModel.currentDate.formatted(.dateTime.month(.wide).day()))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.purse(with: 24))
                    .foregroundStyle(.black)
                
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.birhdatePets) { pet in
                        PetCellView(pet: pet, isDisable: false) {
                            selectedPet = pet
                            isShowTabBar = false
                            isShowDetailView.toggle()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarView(isShowTabBar: .constant(false))
}
