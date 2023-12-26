//
//  MyProfileViewModel.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/19/23.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
class MyProfileViewModel: ObservableObject {
    
    @Published var userInfo: User?
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            Task {
                await updateProfileImage(pickerItem: imageSelection)
            }
        }
    }
    @Published var isPresentedDescEditView: Bool = false
    
    private let userId: String
    
    private var container: DIContainable
    
    init(container: DIContainable, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    func getUser() async {
        if let user = try? await container.services.userService.getUser(userId: userId) {
            userInfo = user
        }
    }
    
    func updateDescription(_ description: String) async {
        do {
            try await container.services.userService.updateDescription(userId: userId, description: description)
            userInfo?.descripton = description
        } catch {
            
        }
    }
    
    func updateProfileImage(pickerItem: PhotosPickerItem?) async {
        guard let pickerItem else { return }
        
        do {
            // picked image data
            let data = try await container.services.photoPickerService.loadTransferable(from: pickerItem)
            
            // upload to stoarge
            let url = try await container.services.uploadService.uploadImage(source: .profile(userId: userId), data: data)
            
            // db update
            try await container.services.userService.updateProfileURL(userId: userId, profileURL: url.absoluteString)
            
            // UI update
            userInfo?.profileURL = url.absoluteString
        } catch {
            print(error.localizedDescription)
        }
    }
}
