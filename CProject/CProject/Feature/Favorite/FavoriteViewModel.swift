//
//  FavoriteViewModel.swift
//  CProject
//
//  Created by Choi Oliver on 2/15/24.
//

import Foundation

final class FavoriteViewModel {
    enum Action {
        case getFavoriteFromAPI
        
        case didTapPurchaseButton
        
        case getFavoriteSuccess(FavoriteResponse)
        case getFavoriteFailure(Error)
    }
    
    final class State {
        @Published var tableViewModel: [FavoriteItemTableViewCellViewModel]?
    }
    
    private(set) var state: State = .init()
    
    func process(action: Action) {
        switch action {
        case .getFavoriteFromAPI:
            loadFavoriteFromAPI()
        case .didTapPurchaseButton:
            break
        case let .getFavoriteSuccess(response):
            translateFavoriteItemViewModel(response)
        case let .getFavoriteFailure(error):
            print(error)
        }
    }
}

extension FavoriteViewModel {
    private func loadFavoriteFromAPI() {
        Task {
            do {
                let response = try await NetworkService.shared.getFavoriteData()
                process(action: .getFavoriteSuccess(response))
            } catch {
                process(action: .getFavoriteFailure(error))
            }
        }
    }
    
    private func translateFavoriteItemViewModel(_ response: FavoriteResponse) {
        state.tableViewModel = response.favorites.map {
            FavoriteItemTableViewCellViewModel(
                imageUrlString: $0.imageUrl,
                productName: $0.title,
                productPrice: $0.discountPrice.moneyString
            )
        }
    }
}
