import SwiftUI

struct NotificationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("isNotificationSetup") var isNotificationSetup = false
    @AppStorage("theDayBeforeEnabled") var theDayBeforeEnabled = false
    @AppStorage("oneWeekBeforeEnable") var oneWeekBeforeEnable = false
    
    @State private var isNotificationEnable = false
    @State private var isShowNotificationAlert = false
    
    var body: some View {
        ZStack {
            ZStack {
                Image(.Images.bg)
                    .aduptImage()
                
                VStack {
                    navigation
                    image
                    cells
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 35)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            isNotificationEnable = isNotificationSetup
        }
        .onChange(of: isNotificationEnable) { isEnable in
            if isEnable {
                Task {
                    switch await PushPermissionManager.shared.status {
                        case .authorized:
                            isNotificationSetup = isEnable
                        case .denied:
                            isShowNotificationAlert = true
                        case .notDetermined:
                            await PushPermissionManager.shared.requestAccess()
                    }
                }
            } else {
                isNotificationSetup = false
            }
        }
        .alert("Notification permission wasn't allowed", isPresented: $isShowNotificationAlert) {
            Button("Yes") {
                openSettings()
            }
            
            Button("No") {
                isNotificationEnable = false
            }
        } message: {
            Text("Open app settings?")
        }
    }
    
    private var navigation: some View {
        ZStack {
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
            
            Text("Notifications")
                .font(.purse(with: 35))
                .foregroundStyle(.black)
        }
        .frame(height: 44)
    }
    
    private var image: some View {
        Image(.Images.Settings.notification)
            .resizable()
            .scaledToFit()
            .frame(width: 136, height: 178)
            .padding(.top, 30)
    }
    
    private var cells: some View {
        VStack(spacing: 16) {
            toggle
            
            if isNotificationEnable {
                VStack(spacing: 8) {
                    dayBefore
                    weekBefore
                }
            }
        }
        .padding(.top, 40)
        .animation(.easeInOut(duration: 0.3), value: isNotificationEnable)
    }
    
    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    private var toggle: some View {
        HStack {
            Text("Notifications")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.purse(with: 20))
                .foregroundStyle(.black)
            
            Toggle(isOn: $isNotificationEnable) {}
                .labelsHidden()
                .tint(.customRed)
        }
        .frame(minHeight: 60)
        .padding(.horizontal, 12)
        .background(.white)
        .cornerRadius(27)
    }
    
    private var dayBefore: some View {
        Button {
            theDayBeforeEnabled.toggle()
        } label: {
            HStack(spacing: 8) {
                Circle()
                    .stroke(.customRed, lineWidth: 1)
                    .frame(width: 25, height: 25)
                    .overlay {
                        if theDayBeforeEnabled {
                            Circle()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.customRed)
                        }
                    }
                
                Text("The day before")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.purse(with: 20))
                    .foregroundStyle(.black)
            }
            .frame(minHeight: 60)
            .padding(.horizontal, 12)
            .background(.white)
            .cornerRadius(27)
        }
    }
    
    private var weekBefore: some View {
        Button {
            oneWeekBeforeEnable.toggle()
        } label: {
            HStack(spacing: 8) {
                Circle()
                    .stroke(.customRed, lineWidth: 1)
                    .frame(width: 25, height: 25)
                    .overlay {
                        if oneWeekBeforeEnable {
                            Circle()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.customRed)
                        }
                    }
                
                Text("One week before")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.purse(with: 20))
                    .foregroundStyle(.black)
            }
            .frame(minHeight: 60)
            .padding(.horizontal, 12)
            .background(.white)
            .cornerRadius(27)
        }
    }
}

#Preview {
    NotificationView()
}
