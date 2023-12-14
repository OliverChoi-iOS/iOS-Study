//
//  BookmarkViewModel.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/14.
//

import Foundation

@MainActor class BookmarkViewModel {
    private(set) var bookmark: Bookmark?
    var dataChanged: (() -> Void)?
    
    init(
        bookmark: Bookmark? = nil,
        dataChanged: (() -> Void)? = nil
    ) {
        self.bookmark = bookmark
        self.dataChanged = dataChanged
    }
    
    func requestData() {
        Task {
            do {
                let bookmark = try await DataLoader.load(url: URLDefines.bookmark, for: Bookmark.self)
                self.bookmark = bookmark
                self.dataChanged?()
            } catch {
                print("‼️ data load failed: \(error.localizedDescription)")
            }
        }
    }
}
