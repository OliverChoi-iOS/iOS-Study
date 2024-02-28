//
//  DetailRootView.swift
//  CProject
//
//  Created by Choi Oliver on 2/15/24.
//

import SwiftUI
import Kingfisher

struct DetailRootView: View {
    
    @StateObject var viewModel: DetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.state.isLoading {
                Text("로딩중...")
            } else {
                if let error = viewModel.state.isError {
                    Text(error)
                } else {
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            bannerView
                            rateView
                            titleView
                            optionView
                            priceView
                            mainImageView
                        }
                    } // ScrollView
                }
            }
            
            moreView
            bottomCtaView
        } // VStack
        .onAppear(perform: {
            viewModel.process(action: .loadData)
        })
    }
    
    @ViewBuilder
    var bannerView: some View {
        if let bannerViewModel = viewModel.state.bannerViewModel {
            DetailBannerView(viewModel: bannerViewModel)
                .padding(.bottom, 15)
        }
    }
    @ViewBuilder
    var rateView: some View {
        if let rateViewModel = viewModel.state.rateViewModel {
            DetailRateView(viewModel: rateViewModel)
                .padding(.horizontal, 20)
        }
    }
    @ViewBuilder
    var titleView: some View {
        if let title = viewModel.state.title {
            HStack {
                Text(title)
                    .font(CPFont.SwiftUI.m17)
                    .foregroundStyle(CPColor.SwiftUI.bk)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
    @ViewBuilder
    var optionView: some View {
        if let optionViewModel = viewModel.state.optionViewModel {
            DetailOptionView(viewModel: optionViewModel)
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            
            HStack {
                Spacer()
                Button(action: {
                    viewModel.process(action: .didTapChangeOption)
                }, label: {
                    Text("옵션 선택하기")
                        .font(CPFont.SwiftUI.m12)
                        .foregroundStyle(CPColor.SwiftUI.keyColorBlue)
                })
            }
            .padding(.horizontal, 20)
        }
    }
    @ViewBuilder
    var priceView: some View {
        if let priceViewModel = viewModel.state.priceViewModel {
            DetailPriceView(viewModel: priceViewModel)
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
        }
    }
    @ViewBuilder
    var mainImageView: some View {
        if let mainImageUrls = viewModel.state.mainImageUrls {
            LazyVStack(spacing: 0) {
                ForEach(mainImageUrls, id: \.self) {
                    KFImage(URL(string: $0))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width)
                        .clipped()
                        .contentShape(Rectangle())
                }
            }
            .padding(.bottom, 32)
            .frame(maxHeight: viewModel.state.moreViewModel == nil ? .infinity : 200, alignment: .top)
            .clipped()
        }
    }
    
    @ViewBuilder
    var moreView: some View {
        if let moreViewModel = viewModel.state.moreViewModel {
            DetailMoreView(
                viewModel: moreViewModel,
                onMoreTapped: {
                    viewModel.process(action: .didTapMore)
                }
            )
        }
    }
    @ViewBuilder
    var bottomCtaView: some View {
        if let purchaseViewModel = viewModel.state.purchaseViewModel {
            DetailPurchaseView(
                viewModel: purchaseViewModel,
                onFavoriteTapped: {
                    viewModel.process(action: .didTapFavorite)
                },
                onPurchaseTapped: {
                    viewModel.process(action: .didTapPurchase)
                }
            )
            .padding(.horizontal, 25)
        }
    }
}

#Preview {
    DetailRootView(viewModel: .init())
}
