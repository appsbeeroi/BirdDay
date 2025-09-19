import SwiftUI

struct StrokeText: View {
    
    let text: String
    let fontSize: CGFloat
    let firstColor: Color?
    let secondColor: Color?
    let lineLimit: Int?
    
    init(
        _ text: String,
        fontSize: CGFloat,
        firstColor: Color? = nil,
        secondColor: Color? = nil,
        lineLimit: Int? = nil
    ) {
        self.text = text
        self.fontSize = fontSize
        self.firstColor = firstColor
        self.secondColor = secondColor
        self.lineLimit = lineLimit
    }
    
    var body: some View {
        ZStack {
            Group {
                Text(text).offset(x: 0, y: 4)
                Text(text).offset(x: 0, y: 5)
            }
            .font(.purse(with: fontSize))
            .foregroundStyle(secondColor == nil ? .black : secondColor ?? .black)
            .multilineTextAlignment(.center)
            
            Text(text)
                .font(.purse(with: fontSize))
                .foregroundStyle(firstColor ?? .white)
                .multilineTextAlignment(.center)
                .lineLimit(lineLimit)
        }
    }
}

#Preview {
    ZStack {
        Color.gray
        
        StrokeText("FIND THESE", fontSize: 56)
    }
}
