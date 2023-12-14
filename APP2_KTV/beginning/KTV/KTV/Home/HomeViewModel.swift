//
//  HomeViewModel.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/13.
//

import Foundation

@MainActor class HomeViewModel {
    private(set) var home: Home?
    let recommendViewModel: HomeRecommendViewModel = .init()
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
                let home = try await DataLoader.load(url: URLDefines.home, for: Home.self)
                self.home = home
                self.recommendViewModel.recommends = home.recommends
                self.dataChanged?()
            } catch {
                print("‼️ data load failed: \(error.localizedDescription)")
            }
        }
    }
}
