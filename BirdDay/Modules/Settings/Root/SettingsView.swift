import SwiftUI

struct SettingsView: View {
    
    @Binding var isShowTabBar: Bool
    
    @State private var selectedCelType: SettingsCellType?
    
    @State private var isShowNotificationsView = false
    @State private var isShareApp = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.Images.bg)
                    .aduptImage()
                
                VStack {
                    navigation
                    cells
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                if let selectedCelType,
                   let url = URL(string: selectedCelType.urlString) {
                    WebView(url: url) {
                        self.selectedCelType = nil
                        self.isShowTabBar = true
                    }
                    .ignoresSafeArea(edges: [.bottom])
                }
            }
            .navigationDestination(isPresented: $isShowNotificationsView) {
                NotificationView()
            }
            .onAppear {
                isShowTabBar = true
            }
            .sheet(isPresented: $isShareApp) {
                ActivityViewController(activityItems: ["https://apps.apple.com/app/idАЙДИ"])
            }
        }
    }
    #warning("вставить id")
    private var navigation: some View {
        Text("Settings")
            .padding(.top, 30)
            .font(.purse(with: 35))
            .foregroundStyle(.black)
    }
    
    private var cells: some View {
        VStack(spacing: 8) {
            ForEach(SettingsCellType.allCases) { type in
                SettingsCellView(type: type) {
                    isShowTabBar = false
                    
                    if type == .notifications {
                        isShowNotificationsView.toggle()
                    } else {
                        selectedCelType = type
                    }
                }
            }
            
            shareButton
        }
        .padding(.top, 40)
        .padding(.horizontal, 35)
    }
    
    private var shareButton: some View {
        Button {
            isShareApp.toggle()
        } label: {
            Text("Export")
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .font(.purse(with: 22))
                .background(.customGreen)
                .foregroundStyle(.white)
                .cornerRadius(20)
        }
    }
}

#Preview {
    SettingsView(isShowTabBar: .constant(false))
}

