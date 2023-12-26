//
//  LMessengerApp.swift
//  LMessenger
//
//

import SwiftUI

@main
struct LMessengerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var container: DIContainer = .init(services: Services())
    @AppStorage(AppStorageType.Appearance) var appearanceValue: Int = UserDefaults.standard.integer(forKey: AppStorageType.Appearance)
    
    var body: some Scene {
        WindowGroup {
            AuthenticatedView(
                authViewModel: .init(container: container)
            )
            .environmentObject(container)
            .onAppear {
                container.appearanceController.changeAppearance(AppearanceType(rawValue: appearanceValue) ?? .automatic)
            }
        }
    }
}
