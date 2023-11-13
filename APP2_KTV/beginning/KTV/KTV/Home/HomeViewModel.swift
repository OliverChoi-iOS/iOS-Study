//
//  HomeViewModel.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/13.
//

import Foundation

class HomeViewModel {
    private(set) var home: Home?
    var dataChanged: (() -> Void)?
    
    init(
        home: Home? = nil,
        dataChanged: (() -> Void)? = nil
    ) {
        self.home = home
        self.dataChanged = dataChanged
    }
    
    func requestData() {
        Task {
            do {
                self.home = try await DataLoader.load(url: URLDefines.home, for: Home.self)
                self.dataChanged?()
            } catch {
                print("‼️ data load failed: \(error.localizedDescription)")
            }
        }
    }
}
