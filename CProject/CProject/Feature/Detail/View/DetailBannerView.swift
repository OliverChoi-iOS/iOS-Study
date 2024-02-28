//
//  DetailBannerView.swift
//  CProject
//
//  Created by Choi Oliver on 2/15/24.
//

import SwiftUI
import Kingfisher

final class DetailBannerViewModel: ObservableObject {
    @Published var imageUrls: [String]
    
    init(imageUrls: [String]) {
        self.imageUrls = imageUrls
    }
}

struct DetailBannerView: View {
    
    var viewModel: DetailBannerViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(viewModel.imageUrls, id: \.self) { imageUrl in
                    KFImage(URL(string: imageUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .contentShape(Rectangle())
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.never)
    }
}

#Preview {
    DetailBannerView(
        viewModel: .init(
            imageUrls: [
                "https://picsum.photos/id/1/500/500",
                "https://picsum.photos/id/2/500/500",
                "https://picsum.photos/id/3/500/500"
            ]
        )
    )
}
