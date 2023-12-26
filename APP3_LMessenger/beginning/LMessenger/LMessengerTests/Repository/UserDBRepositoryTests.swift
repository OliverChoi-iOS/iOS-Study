//
//  UserDBRepositoryTests.swift
//  LMessengerTests
//
//  Created by Choi Oliver on 12/26/23.
//

import XCTest
import Combine
@testable import LMessenger

final class UserDBRepositoryTests: XCTestCase {
    
    private var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_getUser_success() {
        // given
        let stubUserId = "user1_id"
        let stubData = [
            "id": stubUserId,
            "name": "user1"
        ]
        
        let userDBRepository = UserDBRepository(reference: StubUserDBReference(value: stubData))
        
        userDBRepository.getUser(userId: stubUserId)
            .sink { result in
                // when
                if case let .failure(error) = result {
                    // then
                    XCTFail("Unexpacted fail: \(error)")
                }
            } receiveValue: { userObject in // when
                // then
                XCTAssertNotNil(userObject)
                XCTAssertEqual(userObject.id, stubUserId)
                XCTAssertEqual(userObject.name, "user1")
            }.store(in: &subscriptions)
    }
    
    func test_getUser_success_async() {
        // given
        let stubUserId = "user1_id"
        let stubData = [
            "id": stubUserId,
            "name": "user1"
        ]
        
        let userDBRepository = UserDBRepository(reference: StubUserDBReference(value: stubData))
        
        let exp = XCTestExpectation(description: "getUser")
        
        userDBRepository.getUser(userId: stubUserId)
            .sink { result in
                // when
                if case let .failure(error) = result {
                    // then
                    XCTFail("Unexpacted fail: \(error)")
                    exp.fulfill()
                }
            } receiveValue: { userObject in // when
                // then
                XCTAssertNotNil(userObject)
                XCTAssertEqual(userObject.id, stubUserId)
                XCTAssertEqual(userObject.name, "user1")
                exp.fulfill()
            }.store(in: &subscriptions)
        
        wait(for: [exp], timeout: 2)
    }
    
    func test_getUser_empty() {
        // given
        let stubUserId = "user1_id"
        
        let userDBRepository = UserDBRepository(reference: StubUserDBReference(value: nil))
        
        userDBRepository.getUser(userId: stubUserId)
            .sink { result in
                // when
                if case let .failure(error) = result {
                    // then
                    XCTAssertNotNil(error)
                    XCTAssertEqual(error.localizedDescription, DBError.emptyValue.localizedDescription)
                }
            } receiveValue: { userObject in // when
                // then
                XCTFail("Unexpacted success: \(userObject)")
            }.store(in: &subscriptions)
    }
    
    func test_getUser_fail() {
        // given
        let stubUserId = "user1_id"
        let stubData = [
            "id_modifier": stubUserId,
            "name_modifier": "user1"
        ]
        
        let userDBRepository = UserDBRepository(reference: StubUserDBReference(value: stubData))
        
        userDBRepository.getUser(userId: stubUserId)
            .sink { result in
                // when
                if case let .failure(error) = result {
                    // then
                    XCTAssertNotNil(error)
                }
            } receiveValue: { userObject in // when
                // then
                XCTFail("Unexpacted success: \(userObject)")
            }.store(in: &subscriptions)
    }
}

struct StubUserDBReference: DBReferenceType {
    
    let value: Any?
    
    func setValue(key: String, path: String?, value: Any) -> AnyPublisher<Void, DBError> {
        Just(()).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func setValue(key: String, path: String?, value: Any) async throws {
        
    }
    
    func setValues(_ values: [String : Any]) -> AnyPublisher<Void, DBError> {
        Just(()).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func fetch() -> AnyPublisher<Any?, DBError> {
        Just(value).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func fetch(key: String, path: String?) -> AnyPublisher<Any?, DBError> {
        Just(value).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func fetch(key: String, path: String?) async throws -> Any? {
        return value
    }
    
    func filter(key: String, path: String?, orderedName: String, queryString: String) -> AnyPublisher<Any?, DBError> {
        Just(nil).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func childByAutoId(key: String, path: String?) -> String? {
        return nil
    }
    
    func observeChildAdded(key: String, path: String?) -> AnyPublisher<Any?, DBError> {
        Just(value).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func removeObservedHandlers() {
        
    }
}
