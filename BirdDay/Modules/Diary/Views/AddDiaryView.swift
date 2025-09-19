import SwiftUI

struct AddDiaryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var diary: DiaryNote
    
    let saveAction: (DiaryNote) -> Void
    
    @State private var isShowImagePicker = false
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            Image(.Images.bg)
                .aduptImage()
            
            VStack {
                navigation
                image
                noteInput
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 35)
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $isShowImagePicker) {
            ImagePicker(selectedImage: $diary.image)
        }
    }
    
    private var navigation: some View {
        ZStack {
            Text("Add an entry")
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
                    saveAction(diary)
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundStyle(.customRed.opacity(diary.isClose ? 0.5 : 1))
                }
                .disabled(diary.isClose)
            }
        }
        .padding(.top, 30)
    }
    
    private var image: some View {
        Button {
            isShowImagePicker.toggle()
        } label: {
            ZStack {
                if let image = diary.image {
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
    
    private var noteInput: some View {
        HStack {
            ZStack {
                Text(diary.note == "" ? "Notes" : diary.note)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing, 30)
                    .font(.purse(with: 20))
                    .foregroundStyle(diary.note == "" ? .customGray : .black)
                    .multilineTextAlignment(.leading)
                    .overlay {
                        TextEditor(text: $diary.note)
                            .frame(maxWidth: .infinity)
                            .opacity(0.01)
                            .focused($isFocused)
                    }
                    .onTapGesture {
                        isFocused = true
                    }
            }
            .overlay(alignment: .topTrailing) {
                if diary.note != "" {
                    VStack {
                        Button {
                            diary.note = ""
                            isFocused = false 
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.customGray.opacity(0.5))
                        }
                    }
                }
            }
        }
        .padding(.vertical, 17)
        .padding(.horizontal, 12)
        .background(.white)
        .cornerRadius(27)
    }
}

#Preview {
    AddDiaryView(diary: DiaryNote(isTrue: false)) { _ in }
}

