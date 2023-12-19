//
//  MyProfileDescEditView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/19/23.
//

import SwiftUI

struct MyProfileDescEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State var description: String
    
    var onCompleted: (String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("상태메시지를 입력햊세요", text: $description)
                    .multilineTextAlignment(.center)
            }
            .toolbar {
                Button("완료") {
                    dismiss()
                    onCompleted(description)
                }
                .disabled(description.isEmpty)
            }
        }
    }
}

#Preview {
    MyProfileDescEditView(description: "", onCompleted: { _ in })
}
