//
//  HomeViewModel.swift
//  CProject
//
//  Created by Choi Oliver on 2/14/24.
//

import Foundation
import Combine

final class HomeViewModel {
    enum Action {
        case loadData
        case loadCoupon
        
        case didTapCouponButton
        
        case getDataSucess(HomeResponse)
        case getDataFailure(Error)
        case getCouponSuccess(Bool)
    }
    
    final class State {
        struct CollectionViewModels {
            var bannerViewModels: [HomeBannerCollectionViewCellViewModel]?
            var horizontalProductViewModels: [HomeProductCollectionViewCellViewModel]?
            var verticalProductViewModels: [HomeProductCollectionViewCellViewModel]?
            var couponState: HomeCouponButtonCollectionViewCellViewModel?
            var seperateLine1ViewModel: HomeSeperateLineCollectionViewCellViewModel = .init(id: 1)
            var seperateLine2ViewModel: HomeSeperateLineCollectionViewCellViewModel = .init(id: 2)
            var themeViewModels: (header: HomeThemeHeaderCollectionReusableViewModel, items: [HomeThemeCollectionViewCellViewModel])?
        }
        
        @Published var collectionViewModels: CollectionViewModels = .init()
    }
    
    private(set) var state: State = .init()
    private var loadDataTask: Task<Void, Never>?
    private let couponDownloadedKey: String = "CouponDownloaded"
    
    func process(action: Action) {
        switch action {
        case .loadData:
            loadData()
        case .loadCoupon:
            loadCoupon()
            
        case .didTapCouponButton:
            downloadCoupon()
            
        case let .getDataSucess(response):
            transformResponse(response)
        case let .getDataFailure(error):
            print("network error: \(error)")
        case let .getCouponSuccess(isDownloaded):
            Task { await transformCoupon(isDownloaded) }
        }
    }
    
    deinit {
        loadDataTask?.cancel()
    }
}

extension HomeViewModel {
    
    private func loadData() {
        loadDataTask = Task {
            do {
                let homeResponse = try await NetworkService.shared.getHomeData()
                process(action: .getDataSucess(homeResponse))
            } catch {
                process(action: .getDataFailure(error))
            }
        }
    }
    
    private func loadCoupon() {
        let couponState: Bool = UserDefaults.standard.bool(forKey: couponDownloadedKey)
        process(action: .getCouponSuccess(couponState))
    }
    
    private func downloadCoupon() {
        UserDefaults.standard.setValue(true, forKey: couponDownloadedKey)
        process(action: .loadCoupon)
    }
    
    private func transformResponse(_ response: HomeResponse) {
        Task { await transformBanner(response) }
        Task { await transformHorizontalProduct(response) }
        Task { await transformVerticalProduct(response) }
        Task { await transformTheme(response) }
    }
    
    @MainActor
    private func transformBanner(_ response: HomeResponse) async {
        state.collectionViewModels.bannerViewModels = response.banners.map {
            HomeBannerCollectionViewCellViewModel(bannerImageUrl: $0.imageUrl)
        }
    }
    
    @MainActor
    private func transformHorizontalProduct(_ response: HomeResponse) async {
        state.collectionViewModels.horizontalProductViewModels = productsToHomeProductCollectionViewCellViewModels(response.horizontalProducts)
    }
    
    @MainActor
    private func transformVerticalProduct(_ response: HomeResponse) async {
        state.collectionViewModels.verticalProductViewModels = productsToHomeProductCollectionViewCellViewModels(response.verticalProducts)
    }
    
    @MainActor
    private func transformTheme(_ response: HomeResponse) async {
        let items: [HomeThemeCollectionViewCellViewModel] = response.themes.map {
            HomeThemeCollectionViewCellViewModel(themeImageUrl: $0.imageUrl)
        }
        
        state.collectionViewModels.themeViewModels = (header: HomeThemeHeaderCollectionReusableViewModel(headerText: "테마관"), items: items)
    }
    
    @MainActor
    private func transformCoupon(_ isDownloaded: Bool) {
        state.collectionViewModels.couponState = HomeCouponButtonCollectionViewCellViewModel(state: isDownloaded ? .disable : .enable)
    }
    
    private func productsToHomeProductCollectionViewCellViewModels(_ products: [Product]) -> [HomeProductCollectionViewCellViewModel] {
        return products.map {
            HomeProductCollectionViewCellViewModel(
                imageUrlString: $0.imageUrl,
                title: $0.title,
                reasonDiscountString: $0.discount,
                originalPrice: $0.originalPrice.moneyString,
                discountPrice: $0.discountPrice.moneyString
            )
        }
    }
}
