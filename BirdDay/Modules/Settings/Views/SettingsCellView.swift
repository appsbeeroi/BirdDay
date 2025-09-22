import SwiftUI

struct SettingsCellView: View {
    
    let type: SettingsCellType
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(type.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.purse(with: 20))
                    .foregroundStyle(.black)
                
                Image(systemName: "arrow.forward")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.customRed)
            }
            .frame(minHeight: 60)
            .padding(.horizontal, 12)
            .background(.white)
            .cornerRadius(27)
        }
    }
}
