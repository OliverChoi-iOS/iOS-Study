//
//  VideoViewModel.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/16.
//

import Foundation

@MainActor class VideoViewModel {
    private(set) var video: Video?
    var dataChanged: ((Video) -> Void)?
    
    func request() {
        Task {
            do {
                let video = try await DataLoader.load(url: URLDefines.video, for: Video.self)
                self.video = video
                self.dataChanged?(video)
            } catch {
                print("‼️ data load failed: \(error.localizedDescription)")
            }
        }
    }
}
