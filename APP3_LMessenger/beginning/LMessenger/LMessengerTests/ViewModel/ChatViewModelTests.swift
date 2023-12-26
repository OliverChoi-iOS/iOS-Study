//
//  ChatViewModelTests.swift
//  LMessengerTests
//
//  Created by Choi Oliver on 12/26/23.
//

import XCTest
import Combine
@testable import LMessenger

final class ChatViewModelTests: XCTestCase {
    
    private var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {}

    func test_addChat_equal_date() {
        let viewModel: ChatViewModel = .init(
            container: DIContainer.stub,
            chatRoomId: "chatRoom1_id",
            myUserId: "user1_id",
            otherUserId: "user2_id"
        )
        let date: Date = Date(year: 2023, month: 12, day: 26)!
        viewModel.updateChatDataList(Chat(chatId: "chat1_id", userId: "user1_id", date: date))
        viewModel.updateChatDataList(Chat(chatId: "chat2_id", userId: "user1_id", date: date))
        viewModel.updateChatDataList(Chat(chatId: "chat3_id", userId: "user1_id", date: date))
        viewModel.updateChatDataList(Chat(chatId: "chat4_id", userId: "user1_id", date: date))
        
        XCTAssertEqual(viewModel.chatDataList.count, 1)
        XCTAssertNotNil(viewModel.chatDataList.first)
        XCTAssertEqual(viewModel.chatDataList.first?.chats.count, 4)
    }
    
    func test_addChat_different_date() {
        let viewModel: ChatViewModel = .init(
            container: DIContainer.stub,
            chatRoomId: "chatRoom1_id",
            myUserId: "user1_id",
            otherUserId: "user2_id"
        )
        
        var date: Date = Date(year: 2023, month: 12, day: 25)!
        viewModel.updateChatDataList(Chat(chatId: "chat1_id", userId: "user1_id", date: date))
        viewModel.updateChatDataList(Chat(chatId: "chat2_id", userId: "user1_id", date: date))
        date = date.addingTimeInterval(24 * 60 * 60)
        viewModel.updateChatDataList(Chat(chatId: "chat3_id", userId: "user1_id", date: date))
        date = date.addingTimeInterval(24 * 60 * 60)
        viewModel.updateChatDataList(Chat(chatId: "chat4_id", userId: "user1_id", date: date))
        
        XCTAssertEqual(viewModel.chatDataList.count, 3)
        XCTAssertEqual(viewModel.chatDataList[0].chats.count, 2)
        XCTAssertEqual(viewModel.chatDataList[1].chats.count, 1)
        XCTAssertEqual(viewModel.chatDataList[2].chats.count, 1)
    }
}

