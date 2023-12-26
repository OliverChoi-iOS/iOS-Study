//
//  SearchView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.managedObjectContext) var objectContext
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack {
            topView
            
            if viewModel.searchResults.isEmpty {
                RecentSearchView()
            } else {
                List {
                    ForEach(viewModel.searchResults) { result in
                        Button {
                            homeViewModel.modalDestination = .otherProfile(result.id)
                        } label: {
                            HStack(spacing: 8) {
                                URLImageView(urlString: result.profileURL)
                                    .frame(width: 26, height: 26)
                                    .clipShape(Circle())
                                
                                Text(result.name)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(Color.bkText)
                            }
                        }
                        .listRowInsets(.init())
                        .listRowSeparator(.hidden)
                        .padding(.horizontal, 30)
                        .buttonStyle(.plain)
                    }
                }
                .listStyle(.plain)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
    
    var topView: some View {
        HStack(spacing: 0) {
            Button {
                container.navigationRouter.pop()
            } label: {
                Image("back")
            }
            
            SearchBar(
                text: $viewModel.searchText, 
                shouldBecomeFirstResponder: $viewModel.shouldBecomeFirstResponder,
                onClickedSearchButton: {
                    self.setSearchResultWithContext()
                }
            )
            
            Button {
                viewModel.send(action: .clearSearchText)
            } label: {
                Image("close_search")
            }
        }
        .padding(.horizontal, 20)
    }
    
    func setSearchResultWithContext() {
        let result = SearchResult(context: objectContext)
        result.id = UUID().uuidString
        result.name = viewModel.searchText
        result.date = Date()
        
        try? objectContext.save()
    }
}

#Preview {
    let container: DIContainer = .init(services: StubService())
    let searchDataController: SearchDataController = .init()
    let homeViewModel: HomeViewModel = .init(container: container, userId: "user1_id")
    
    return SearchView(
        viewModel: .init(container: container, userId: "user1_id")
    )
    .environmentObject(container)
    .environment(\.managedObjectContext, searchDataController.persistantContainer.viewContext)
    .environmentObject(homeViewModel)
}
