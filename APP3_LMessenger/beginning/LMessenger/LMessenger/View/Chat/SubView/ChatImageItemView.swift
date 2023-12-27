//
//  ChatImageItemView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/21/23.
//

import SwiftUI

struct ChatImageItemView: View {
    let urlString :String
    let direction: ChatItemDirection
    let date: Date
    
    var body: some View {
        HStack {
            if direction == .right {
                Spacer()
                dateView
            }
            
            URLImageView(urlString: urlString)
                .frame(width: 146, height: 146)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            if direction == .left {
                dateView
                Spacer()
            }
        }
        .padding(.horizontal, 35)
    }
    
    var dateView: some View {
        Text(date.toChatTime)
            .font(.system(size: 10))
            .foregroundStyle(Color.greyDeep)
            .accessibilityLabel(Text(date.toChatTimeAccessibility))
    }
}

#Preview {
    ChatImageItemView(urlString: "", direction: .right, date: Date())
}
