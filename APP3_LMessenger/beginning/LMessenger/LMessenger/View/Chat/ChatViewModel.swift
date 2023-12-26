//
//  ChatViewModel.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import SwiftUI
import Combine
import PhotosUI

class ChatViewModel: ObservableObject {
    enum Action {
        case load
        case addChat(String)
        case uploadImage(PhotosPickerItem?)
    }
    
    @Published var myUser: User?
    @Published var otherUser: User?
    @Published var chatRoom: ChatRoom?
    @Published var chatDataList: [ChatData] = []
    
    @Published var message: String = ""
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            send(action: .uploadImage(imageSelection))
        }
    }
    
    private let chatRoomId: String
    private let myUserId: String
    private let otherUserId: String
    
    private var container: DIContainable
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        container: DIContainable,
        chatRoomId: String,
        myUserId: String,
        otherUserId: String
    ) {
        self.chatRoomId = chatRoomId
        self.myUserId = myUserId
        self.otherUserId = otherUserId
        self.container = container
        
        bind()
    }
    
    func bind() {
        container.services.chatService.observeChat(chatRoomId: chatRoomId)
            .sink { [weak self] chat in
                guard let self, let chat else { return }
                
                self.updateChatDataList(chat)
            }.store(in: &subscriptions)
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            Publishers.Zip(
                container.services.userService.getUser(userId: myUserId),
                container.services.userService.getUser(userId: otherUserId)
            )
            .sink { completion in
                
            } receiveValue: { [weak self] myUser, otherUser in
                self?.myUser = myUser
                self?.otherUser = otherUser
            }.store(in: &subscriptions)

        case let .addChat(message):
            let newChat: Chat = .init(chatId: UUID().uuidString, userId: myUserId, message: message, date: Date())
            
            container.services.chatService.addChat(newChat, to: chatRoomId)
                .flatMap({ [weak self] chat in
                    guard let self else {
                        return Fail<Void, ServiceError>(error: .selfIsNil).eraseToAnyPublisher()
                    }
                    
                    return container.services.chatRoomService.updateChatRoomLastMessage(chatRoomId: chatRoomId, myUserId: myUserId, myUserName: myUser?.name ?? "", otherUserId: otherUserId, lastMessage: chat.lastMessage)
                })
                .sink { completion in
                    
                } receiveValue: { [weak self] in
                    self?.message = ""
                }.store(in: &subscriptions)

        case let .uploadImage(pickerItem):
            /*
             1. data
             2. uploadservice -> storage
             3. add url chat
             */
            guard let pickerItem else { return }
            
            container.services.photoPickerService.loadTransferable(from: pickerItem)
                .flatMap { [weak self] data in
                    guard let self else {
                        return Fail<URL, ServiceError>(error: .selfIsNil).eraseToAnyPublisher()
                    }
                
                    return container.services.uploadService.uploadImage(source: .chat(chatRoomId: chatRoomId), data: data)
                }
                .flatMap { [weak self] url in
                    guard let self else {
                        return Fail<Chat, ServiceError>(error: .selfIsNil).eraseToAnyPublisher()
                    }
                    
                    let newChat: Chat = .init(chatId: UUID().uuidString, userId: myUserId, message: nil, photoURL: url.absoluteString, date: Date())
                    return container.services.chatService.addChat(newChat, to: chatRoomId)
                }
                .flatMap({ [weak self] chat in
                    guard let self else {
                        return Fail<Void, ServiceError>(error: .selfIsNil).eraseToAnyPublisher()
                    }
                    
                    return container.services.chatRoomService.updateChatRoomLastMessage(chatRoomId: chatRoomId, myUserId: myUserId, myUserName: myUser?.name ?? "", otherUserId: otherUserId, lastMessage: chat.lastMessage)
                })
                .sink { completion in
                    
                } receiveValue: { _ in
                    
                }.store(in: &subscriptions)

        } // switch
    }
}

extension ChatViewModel {
    func updateChatDataList(_ chat: Chat) {
        let key = chat.date.toChatDataKey
        
        if let index = chatDataList.firstIndex(where: { $0.dateStr == key }) {
            chatDataList[index].chats.append(chat)
        } else {
            let newChatData: ChatData = .init(dateStr: key, chats: [chat])
            chatDataList.append(newChatData)
        }
    }
    
    func getDirection(id: String) -> ChatItemDirection {
        myUserId == id ? .right : .left
    }
}
