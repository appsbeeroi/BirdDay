import SwiftUI

struct DiaryView: View {
    
    @StateObject private var viewModel = DiaryViewModel()
    
    @Binding var isShowTabBar: Bool
    
    @State private var selectedDiary: DiaryNote?
    @State private var isShowEntryListView = false
    @State private var isShowDetailView = false
  
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.Images.bg)
                    .aduptImage()
                
                VStack {
                    navigation
                    
                    if viewModel.diaries.isEmpty {
                        stumb
                    } else {
                        notes
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .navigationDestination(isPresented: $isShowEntryListView) {
                EntryListView(
                    diary: selectedDiary ?? DiaryNote(isTrue: true),
                    pets: viewModel.pets) { diary in
                        viewModel.save(diary)
                    }
            }
            .navigationDestination(isPresented: $isShowDetailView) {
                DiaryDetailView(
                    diary: selectedDiary ?? DiaryNote(isTrue: true),
                    pets: viewModel.pets) { newNote in
                        viewModel.save(newNote)
                    } removeAction: { removedNote in
                        viewModel.remove(removedNote)
                    }
            }
            .onAppear {
                isShowTabBar = true
                selectedDiary = nil
                viewModel.loadDiaries()
            }
            .onChange(of: viewModel.isCloseNavigation) { isClose in
                if isClose {
                    isShowDetailView = false
                    isShowEntryListView = false
                    viewModel.isCloseNavigation = false
                }
            }
        }
    }
    
    private var navigation: some View {
        Text("Holiday diary")
            .padding(.top, 30)
            .font(.purse(with: 35))
            .foregroundStyle(.black)
    }
    
    private var stumb: some View {
        VStack(spacing: 24) {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text("Holiday moments are not\nsaved yet")
                        .font(.purse(with: 24))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("Start keeping a mini-diary\nof memories")
                        .font(.purse(with: 16))
                        .foregroundStyle(.customGray)
                        .multilineTextAlignment(.center)
                }
                
                Image(.Images.Diary.book)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 148, height: 133)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 31)
            .background(.white)
            .cornerRadius(25)
            
            addButton
        }
        .padding(.horizontal, 35)
    }
    
    private var addButton: some View {
        Button {
            isShowTabBar = false
            isShowEntryListView.toggle()
        } label: {
            Text("Add an entry")
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .font(.purse(with: 22))
                .foregroundStyle(.white)
                .background(.customRed)
                .cornerRadius(35)
        }
    }
    
    private var notes: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.diaries) { diary in
                    DiaryPetCellView(pets: viewModel.pets, diary: diary) {
                        isShowTabBar = false
                        selectedDiary = diary
                        isShowDetailView.toggle()
                    }
                }
                
                addButton
            }
            .padding(.horizontal, 35)
            
            Color.clear
                .frame(height: 30)
        }
        .padding(.bottom, 110)
    }
}

#Preview {
    DiaryView(isShowTabBar: .constant(false))
}

