import SwiftUI

struct MainTabView: View {
    
    @State private var selection: TabBarSelection = .catalog
    @State private var isShowTabBar: Bool = true
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                CatalogView(isShowTabBar: $isShowTabBar)
                    .tag(TabBarSelection.catalog)
                
                CalendarView(isShowTabBar: $isShowTabBar)
                    .tag(TabBarSelection.calendar)
                
                DiaryView(isShowTabBar: $isShowTabBar)
                    .tag(TabBarSelection.diary)
                
                SettingsView(isShowTabBar: $isShowTabBar)
                    .tag(TabBarSelection.settings)
            }
            
            if isShowTabBar {
                selectionTabBar
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .animation(.easeInOut, value: isShowTabBar)
            }
        }
    }
    
    private var selectionTabBar: some View {
        VStack {
            HStack(spacing: 6) {
                ForEach(TabBarSelection.allCases) { state in
                    Button {
                        selection = state
                    } label: {
                        Circle()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(selection == state ? .customRed : .white)
                            .overlay {
                                Image(state.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(selection == state ? .white : .black)
                            }
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 24)
    }
}

#Preview {
    MainTabView()
}

