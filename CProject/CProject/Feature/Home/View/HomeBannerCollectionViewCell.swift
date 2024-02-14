//
//  HomeBannerCollectionViewCell.swift
//  CProject
//
//  Created by Choi Oliver on 2/14/24.
//

import UIKit
import Kingfisher

struct HomeBannerCollectionViewCellViewModel: Hashable {
    let bannerImageUrl: String
}

final class HomeBannerCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "HomeBannerCollectionViewCell"
    @IBOutlet private weak var imageView: UIImageView!
    
    func setViewModel(_ viewModel: HomeBannerCollectionViewCellViewModel) {
        imageView.kf.setImage(with: URL(string: viewModel.bannerImageUrl))
    }
    
    override func prepareForReuse() {
        imageView.kf.cancelDownloadTask()
    }
}

extension HomeBannerCollectionViewCell {
    static func bannerLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(165 / 393))
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
}
