//
//  RecentSearchView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/21/23.
//

import SwiftUI

struct RecentSearchView: View {
    @Environment(\.managedObjectContext) private var objectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date)]) var results: FetchedResults<SearchResult>
    
    let onItemTapped: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            titleView
                .padding(.bottom, 30)
            
            if results.isEmpty {
                Text("검색 내역이 없습니다.")
                    .font(.system(size: 10))
                    .foregroundStyle(Color.greyDeep)
                    .padding(.vertical, 54)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(results, id: \.self) { result in
                            HStack {
                                Button {
                                    onItemTapped(result.name ?? "")
                                } label: {
                                    Text(result.name ?? "")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.bkText)
                                }
                                Spacer()
                                Button(action: {
                                    objectContext.delete(result)
                                    try? objectContext.save()
                                }, label: {
                                    Image("close_search", label: Text("검색어 삭제"))
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                })
                            }
                            .accessibilityElement(children: .combine)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 30)
    }
    
    var titleView: some View {
        HStack {
            Text("최근 검색어")
                .font(.system(size: 10, weight: .bold))
            
            Spacer()
        }
        .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    let searchDataController: SearchDataController = .init()
    
    return RecentSearchView(onItemTapped: {_ in})
        .environment(\.managedObjectContext, searchDataController.persistantContainer.viewContext)
}
