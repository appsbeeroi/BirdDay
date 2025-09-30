import SwiftUI

struct DiaryPetCellView: View {
    
    let pets: [Pet]
    let diary: DiaryNote
    
    let action: () -> Void
    
    var diaryPets: [Pet] {
        pets.filter { diary.petIDs.contains($0.id) }
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                Image(uiImage: diary.image ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 66, height: 66)
                    .clipped()
                    .cornerRadius(130)
                
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Image(.Images.Icons.calendar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                        
                        Text(diary.date.formatted(.dateTime.year().month(.twoDigits).day()))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.purse(with: 11))
                            .foregroundStyle(.customGray)
                    }
                    
                    HStack {
                        Text("Pets:")
                            .font(.purse(with: 13))
                            .foregroundStyle(.black)
                        
                        ZStack {
                            ForEach(Array(diaryPets.enumerated()), id: \.offset) { index, pet in
                                Image(uiImage: pet.image ?? UIImage())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 20, height: 20)
                                    .clipped()
                                    .cornerRadius(100)
                                    .offset(x: CGFloat(index) * 10)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Image(systemName: "chevron.forward")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.customRed)
            }
            .frame(height: 90)
            .padding(.horizontal, 13)
            .background(.white)
            .cornerRadius(36)
        }
    }
}

#Preview {
    ZStack {
        Image(.Images.bg)
            .ignoresSafeArea()
        DiaryPetCellView(pets: [Pet(isTrue: false), Pet(isTrue: false)],
                         diary: DiaryNote(isTrue: false)) {}
    }
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

extension UIApplication {
    static var keyWindow: UIWindow {
        shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last!
    }
    
    class func topMostController(controller: UIViewController? = keyWindow.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topMostController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController, let selected = tabController.selectedViewController {
            return topMostController(controller: selected)
        }
        if let presented = controller?.presentedViewController {
            return topMostController(controller: presented)
        }
        return controller
    }
}
