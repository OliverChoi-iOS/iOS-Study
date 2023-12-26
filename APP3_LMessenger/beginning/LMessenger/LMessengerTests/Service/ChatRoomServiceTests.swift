//
//  ChatRoomServiceTests.swift
//  LMessengerTests
//
//  Created by Choi Oliver on 12/26/23.
//

import XCTest
import Combine
@testable import LMessenger

final class ChatRoomServiceTests: XCTestCase {
    
    private var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {}
    
    func test_createChatRoomIfNeeded_not_existed() {
        // given
        let stubMyUserId = "user1_id"
        let stubOtherUserId = "user2_id"
        let stubOtherUserName = "user2"
        let mockDBRepository = MockChatRoomDBRepository(mockData: nil)
        
        let chatRoomService = ChatRoomService(dbRepository: mockDBRepository)
        
        chatRoomService
            .createChatRoomIfNeeded(
                myUserId: stubMyUserId,
                otherUserId: stubOtherUserId,
                otherUserName: stubOtherUserName
            ).sink { result in
                if case let .failure(error) = result {
                    XCTFail("Unexpected Fail: \(error)")
                }
            } receiveValue: { chatRoom in
                var result: ChatRoom? = chatRoom
                XCTAssertNotNil(result)
                XCTAssertEqual(result?.otherUserId, stubOtherUserId)
                XCTAssertEqual(result?.otherUserName, stubOtherUserName)
                
                XCTAssertEqual(mockDBRepository.getChatRoomCallCount, 1)
                XCTAssertEqual(mockDBRepository.addChatRoomCallCount, 1)
            }.store(in: &subscriptions)
    }
    
    func test_createChatRoomIfNeeded_existed() {
        // given
        let stubMyUserId = "user1_id"
        let stubOtherUserId = "user2_id"
        let stubOtherUserName = "user2"
        let stubChatRoom: ChatRoomObject = .stub1
        let mockDBRepository = MockChatRoomDBRepository(mockData: stubChatRoom)
        
        let chatRoomService = ChatRoomService(dbRepository: mockDBRepository)
        
        chatRoomService
            .createChatRoomIfNeeded(
                myUserId: stubMyUserId,
                otherUserId: stubOtherUserId,
                otherUserName: stubOtherUserName
            ).sink { result in
                if case let .failure(error) = result {
                    XCTFail("Unexpected Fail: \(error)")
                }
            } receiveValue: { chatRoom in
                var result: ChatRoom? = chatRoom
                XCTAssertNotNil(result)
                XCTAssertEqual(result?.otherUserId, stubOtherUserId)
                XCTAssertEqual(result?.otherUserName, stubOtherUserName)
                
                XCTAssertEqual(mockDBRepository.getChatRoomCallCount, 1)
                XCTAssertEqual(mockDBRepository.addChatRoomCallCount, 0)
            }.store(in: &subscriptions)
    }
}

class MockChatRoomDBRepository: ChatRoomDBRepositoryType {
    let mockData: Any?
    
    var addChatRoomCallCount = 0
    var getChatRoomCallCount = 0
    
    init(mockData: Any?) {
        self.mockData = mockData
    }
    
    func getChatRoom(myUserId: String, otherUserId: String) -> AnyPublisher<ChatRoomObject?, DBError> {
        getChatRoomCallCount += 1
        return Just(mockData as? ChatRoomObject).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func addChatRoom(_ object: ChatRoomObject, myUserId: String) -> AnyPublisher<Void, DBError> {
        addChatRoomCallCount += 1
        return Just(()).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoomObject], DBError> {
        Just([]).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, otherUserId: String, lastMessage: String) -> AnyPublisher<Void, DBError> {
        Just(()).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
}
