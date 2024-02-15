//
//  DetailViewModel.swift
//  CProject
//
//  Created by Choi Oliver on 2/15/24.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    enum Action {
        case loadData
        case loading(Bool)
        
        case didTapChangeOption
        case didTapMore
        case didTapFavorite
        case didTapPurchase
        
        case loadDataSuccess(ProductDetailResponse)
        case loadDataFailure(Error)
    }
    
    struct State {
        var isError: String?
        var isLoading: Bool = false
        var bannerViewModel: DetailBannerViewModel?
        var rateViewModel: DetailRateViewModel?
        var title: String?
        var optionViewModel: DetailOptionViewModel?
        var priceViewModel: DetailPriceViewModel?
        var mainImageUrls: [String]?
        var moreViewModel: DetailMoreViewModel?
        var purchaseViewModel: DetailPurchaseViewModel?
    }
    
    @Published private(set) var state: State = .init()
    private(set) var showOptionViewController: PassthroughSubject<Void, Never> = .init()
    private var loadDataTask: Task<Void, Never>?
    private var isFavorite: Bool = false
    private var needShowMore: Bool = true
    
    func process(action: Action) {
        switch action {
            
        case .loadData:
            loadData()
        case let .loading(isLoading):
            Task { await toggleLoading(isLoading) }
        case .didTapChangeOption:
            showOptionViewController.send()
        case .didTapMore:
            Task { await toggleMore() }
        case .didTapFavorite:
            Task { await toggleFavorite() }
        case .didTapPurchase:
            break
            
        case let .loadDataSuccess(response):
            Task { await transformProductDetail(response) }
        case let .loadDataFailure(error):
            Task { await getDataFailure(error) }
        }
    }
    
    deinit {
        loadDataTask?.cancel()
    }
}

extension DetailViewModel {
    private func loadData() {
        loadDataTask = Task {
            defer {
                process(action: .loading(false))
            }
            
            do {
                process(action: .loading(true))
                let response = try await NetworkService.shared.getProductDetailData()
                process(action: .loadDataSuccess(response))
            } catch {
                process(action: .loadDataFailure(error))
            }
        }
    }
    
    @MainActor
    private func transformProductDetail(_ response: ProductDetailResponse) {
        state.isError = nil
        state.bannerViewModel = .init(imageUrls: response.bannerImages)
        state.title = response.product.name
        state.optionViewModel = .init(type: response.option.type, name: response.option.name, imageUrl: response.option.image)
        state.rateViewModel = .init(rate: response.product.rate)
        state.priceViewModel = .init(discountRate: "\(response.product.discountPercent)%", originPrice: response.product.originalPrice.moneyString, currentPrice: response.product.discountPrice.moneyString, shippingType: "무료배송")
        state.mainImageUrls = response.detailImages
        state.moreViewModel = needShowMore ? .init() : nil
        state.purchaseViewModel = .init(isFavorite: isFavorite)
    }
    
    @MainActor
    private func getDataFailure(_ error: Error) {
        state.isError = "에러가 발생했습니다: \(error.localizedDescription)"
    }
    
    @MainActor
    private func toggleLoading(_ isLoading: Bool) {
        state.isLoading = isLoading
    }
    
    @MainActor
    private func toggleFavorite() {
        isFavorite.toggle()
        state.purchaseViewModel = .init(isFavorite: isFavorite)
    }
    
    @MainActor
    private func toggleMore() {
        needShowMore = false
        state.moreViewModel = needShowMore ? .init() : nil
    }
}
