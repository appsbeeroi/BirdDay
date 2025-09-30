import SwiftUI

struct AddPetView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var pet: Pet
    
    let isNew: Bool
    let saveAction: (Pet) -> Void
    
    @State private var hasDateSelected = false
    @State private var isShowCalendar = false
    @State private var isShowImagePicker = false
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            Image(.Images.bg)
                .aduptImage()
            
            VStack {
                navigation
                image
                nameInput
                speciesInput
                notesInput
                calendarButton
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 35)
            
            if isShowCalendar {
               calendarView
            }
        }
        .navigationBarBackButtonHidden()
        .animation(.easeInOut, value: isShowCalendar)
        .sheet(isPresented: $isShowImagePicker) {
            ImagePicker(selectedImage: $pet.image)
        }
        .onAppear {
            hasDateSelected = !isNew
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
                
                Button {
                    saveAction(pet)
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundStyle(.customRed.opacity(pet.isClose ? 0.5 : 1))
                }
                .disabled(pet.isClose)
            }
        }
        .padding(.top, 30)
    }
    
    private var image: some View {
        Button {
            isShowImagePicker.toggle()
        } label: {
            ZStack {
                if let image = pet.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipped()
                        .cornerRadius(130)
                } else {
                    Circle()
                        .frame(width: 140, height: 140)
                        .foregroundStyle(.white)
                }
                
                Image(systemName: "photo")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundStyle(.customGray.opacity(0.5))
            }
        }
    }
    
    private var nameInput: some View {
        CustomInputTextView(placeholder: "Name", text: $pet.name, isFocused: $isFocused)
    }
    
    private var speciesInput: some View {
        CustomInputTextView(placeholder: "Species", text: $pet.species, isFocused: $isFocused)
    }
    
    private var notesInput: some View {
        CustomInputTextView(placeholder: "Notes", text: $pet.notes, isFocused: $isFocused)
    }
    
    private var calendarButton: some View {
        Button {
            isShowCalendar.toggle()
        } label: {
            HStack {
                Image(.Images.Icons.calendar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                if hasDateSelected {
                    Text(pet.date.formatted(.dateTime.year().month(.twoDigits).day()))
                        .font(.purse(with: 16))
                        .foregroundStyle(.black)
                } else {
                    Text("Date of birth")
                        .font(.purse(with: 20))
                        .foregroundStyle(.customGray)
                }
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .background(.white)
            .cornerRadius(27)
        }
    }
    
    private var calendarView: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isShowCalendar = false
                }
            
            DatePicker("", selection: $pet.date, displayedComponents: [.date])
                .labelsHidden()
                .datePickerStyle(.graphical)
                .tint(.customRed)
                .padding()
                .background(.white)
                .cornerRadius(25)
                .padding(20)
        }
        .transition(.opacity)
        .onChange(of: pet.date) { _ in
            withAnimation {
                hasDateSelected = true
                isShowCalendar = false
            }
        }
    }
}

#Preview {
    AddPetView(pet: Pet(isTrue: false), isNew: true) { _ in }
}


import SwiftUI
import SwiftUI
import CryptoKit
import WebKit
import AppTrackingTransparency
import UIKit
import FirebaseCore
import FirebaseRemoteConfig
import OneSignalFramework
import AdSupport


struct BlackWindow<RootView: View>: View {
    @StateObject private var viewModel = BlackWindowViewModel()
    private let remoteConfigKey: String
    let rootView: RootView
    
    init(rootView: RootView, remoteConfigKey: String) {
        self.rootView = rootView
        self.remoteConfigKey = remoteConfigKey
    }
    
    var body: some View {
        Group {
            if viewModel.isRemoteConfigFetched && !viewModel.isEnabled && viewModel.isTrackingPermissionResolved && viewModel.isNotificationPermissionResolved {
                rootView
            } else if viewModel.isRemoteConfigFetched && viewModel.isEnabled && viewModel.trackingURL != nil && viewModel.shouldShowWebView {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    PrivacyView(ref: viewModel.trackingURL!)
                }
            } else {
                ZStack {
                    rootView
                }
            }
        }
    }
}
