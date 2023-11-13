//
//  HomeRecommendViewModel.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/13.
//

import Foundation

@MainActor class HomeRecommendViewModel {
    private(set) var isFolded: Bool = true {
        didSet {
            self.foldChanged?(isFolded)
        }
    }
    
    var foldChanged: ((Bool) -> Void)?
    
    var recommends: [Home.Recommend]?
    var itemCount: Int {
        let count = self.isFolded ? 5 : self.recommends?.count ?? 0
        
        return min(self.recommends?.count ?? 0, count)
    }
    
    func toggleFoldState() {
        self.isFolded.toggle()
    }
}
