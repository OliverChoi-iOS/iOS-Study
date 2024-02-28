//
//  DetailPriceView.swift
//  CProject
//
//  Created by Choi Oliver on 2/15/24.
//

import SwiftUI

final class DetailPriceViewModel: ObservableObject {
    @Published var discountRate: String
    @Published var originPrice: String
    @Published var currentPrice: String
    @Published var shippingType: String
    
    init(
        discountRate: String,
        originPrice: String,
        currentPrice: String,
        shippingType: String
    ) {
        self.discountRate = discountRate
        self.originPrice = originPrice
        self.currentPrice = currentPrice
        self.shippingType = shippingType
    }
}

struct DetailPriceView: View {
    
    var viewModel: DetailPriceViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 21) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 0) {
                    Text(viewModel.discountRate)
                        .font(CPFont.SwiftUI.b14)
                        .foregroundStyle(CPColor.SwiftUI.icon)
                    Text(viewModel.originPrice)
                        .font(CPFont.SwiftUI.b16)
                        .foregroundStyle(CPColor.SwiftUI.gray5)
                        .strikethrough()
                }
                Text(viewModel.currentPrice)
                    .font(CPFont.SwiftUI.b20)
                    .foregroundStyle(CPColor.SwiftUI.keyColorRed)
            }
            Text(viewModel.shippingType)
                .font(CPFont.SwiftUI.r12)
                .foregroundStyle(CPColor.SwiftUI.icon)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    DetailPriceView(
        viewModel: .init(
            discountRate: "53%",
            originPrice: "300,000원",
            currentPrice: "139,000원",
            shippingType: "무료배송"
        )
    )
}
