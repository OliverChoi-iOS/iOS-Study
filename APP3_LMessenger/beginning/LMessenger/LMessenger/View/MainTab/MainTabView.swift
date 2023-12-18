//
//  MainTabView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/14/23.
//

import SwiftUI
import SwiftUIIntrospect

struct MainTabView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @State private var selectedTab: MainTabType = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        HomeView(viewModel: .init(container: container, userId: authViewModel.userId ?? ""))
                    case .chat:
                        ChatListView()
                    case .phone:
                        Color.blackFix
                    }
                }
                .tabItem {
                    Label(tab.title, image: tab.imageName(selected: selectedTab == tab))
                }
                .tag(tab)
            }
        }
        .tint(.bkText)
        .introspect(.tabView, on: .iOS(.v16, .v17)) {
            $0.tabBar.unselectedItemTintColor = UIColor(Color.bkText)
        }
    }
}

#Preview {
    MainTabView()
}
