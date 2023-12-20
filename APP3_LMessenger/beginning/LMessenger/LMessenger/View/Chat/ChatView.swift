//
//  ChatView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import SwiftUI

struct ChatView: View {
    var chatRoom: ChatRoom
    
    var body: some View {
        Text(chatRoom.otherUserName)
    }
}

#Preview {
    ChatView(chatRoom: ChatRoom.stub1)
}
