//
//  SettingView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/26/23.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: SettingViewModel
    
    @EnvironmentObject private var appearanceController: AppearanceController
    @AppStorage(AppStorageType.Appearance) var appearance: Int = UserDefaults.standard.integer(forKey: AppStorageType.Appearance)
    
    var body: some View {
        LMessengerNavigationStackView {
            List {
                ForEach(viewModel.sectionItems) { section in
                    Section {
                        ForEach(section.settings) { setting in
                            Button {
                                if let a = setting.item as? AppearanceType {
                                    appearanceController.changeAppearance(a)
                                    appearance = a.rawValue
                                }
                            } label: {
                                Text(setting.item.label)
                                    .foregroundColor(.bkText)
                            }
                        }
                    } header: {
                        Text(section.label)
                    }
                }
            }
            .navigationTitle("설정")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image("close_search")
                }
            }
        }
        .preferredColorScheme(appearanceController.appearance.colorScheme)
    }
}

#Preview {
    let container: DIContainer = .init(services: StubService())
    let navigationRouter: NavigationRouter = .init()
    let appearanceController: AppearanceController = .init(AppearanceType.automatic.rawValue)
    
    return SettingView(viewModel: .init())
        .environmentObject(container)
        .environmentObject(navigationRouter)
        .environmentObject(appearanceController)
}
