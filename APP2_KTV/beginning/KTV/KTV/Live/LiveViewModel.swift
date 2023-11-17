//
//  LiveViewModel.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/17.
//

import Foundation

enum LiveSortOption {
    case favorite
    case startTime
}

@MainActor class LiveViewModel {
    private(set) var items: [Live.Item]?
    private(set) var sortOption: LiveSortOption
    var dataChanged: (([Live.Item]) -> Void)?
    
    init(
        items: [Live.Item]? = nil,
        sortOption: LiveSortOption = .favorite,
        dataChanged: (([Live.Item]) -> Void)? = nil
    ) {
        self.items = items
        self.sortOption = sortOption
        self.dataChanged = dataChanged
    }
    
    func request(sort: LiveSortOption) {
        Task {
            do {
                let liveData = try await DataLoader.load(url: URLDefines.live, for: Live.self)
                let items: [Live.Item]
                if sort == .startTime {
                    items = liveData.list.reversed()
                } else {
                    items = liveData.list
                }
                self.items = items
                self.dataChanged?(items)
            } catch {
                print("‼️ \(#file) data load failed: \(error.localizedDescription)")
            }
        }
    }
}
