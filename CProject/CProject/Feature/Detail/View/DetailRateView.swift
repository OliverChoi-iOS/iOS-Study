//
//  DetailRateView.swift
//  CProject
//
//  Created by Choi Oliver on 2/15/24.
//

import SwiftUI

final class DetailRateViewModel: ObservableObject {
    @Published var rate: Int
    
    init(rate: Int) {
        self.rate = rate
    }
}

struct DetailRateView: View {
    
    var viewModel: DetailRateViewModel
    
    var body: some View {
        HStack(spacing: 4) {
            Spacer()
            
            ForEach(0..<viewModel.rate, id: \.self) { _ in
                starImage
                    .foregroundStyle(CPColor.SwiftUI.yellow)
            }
            
            ForEach(viewModel.rate..<5, id: \.self) { _ in
                starImage
                    .foregroundStyle(CPColor.SwiftUI.gray2)
            }
        }
    }
    
    var starImage: some View {
        Image(systemName: "star.fill")
            .resizable()
            .frame(width: 16, height: 16)
    }
}

#Preview {
    DetailRateView(viewModel: .init(rate: 4))
}
