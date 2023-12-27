//
//  SearchViewModel.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/21/23.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    enum Action {
        case requestQuery(String)
        case clearSearchResult
        case clearSearchText
        case setSearchText(String)
    }
    
    @Published var shouldBecomeFirstResponder: Bool = false
    @Published var searchText: String = ""
    @Published var searchResults: [User] = []
    
    private let userId: String
    private var container: DIContainable
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainable, userId: String) {
        self.container = container
        self.userId = userId
        
        bind()
    }
    
    func bind() {
        $searchText
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                if text.isEmpty {
                    self?.send(action: .clearSearchResult)
                } else {
                    self?.send(action: .requestQuery(text))
                }
            }.store(in: &subscriptions)
    }
    
    func send(action: Action) {
        switch action {
        case let .requestQuery(query):
            container.services.userService.filterUsers(with: query, userId: userId)
                .sink { completion in
                    
                } receiveValue: { [weak self] users in
                    self?.searchResults = users
                }.store(in: &subscriptions)

        case .clearSearchResult:
            searchResults = []
            
        case .clearSearchText:
            searchText = ""
            shouldBecomeFirstResponder = false
            searchResults = []
            
        case let .setSearchText(text):
            self.searchText = text
            
        }
    }
}
