//
//  HomeThemeCollectionViewCell.swift
//  CProject
//
//  Created by Choi Oliver on 2/14/24.
//

import UIKit
import Kingfisher

struct HomeThemeCollectionViewCellViewModel: Hashable {
    let themeImageUrl: String
}

class HomeThemeCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "HomeThemeCollectionViewCell"
    
    @IBOutlet private weak var themeImageView: UIImageView!
    
    func setViewModel(_ viewModel: HomeThemeCollectionViewCellViewModel) {
        themeImageView.kf.setImage(with: URL(string: viewModel.themeImageUrl))
    }
    
    override func prepareForReuse() {
        themeImageView.kf.cancelDownloadTask()
    }
}

extension HomeThemeCollectionViewCell {
    static func themeLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let groupFractionalWidth: CGFloat = 0.7
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(groupFractionalWidth), heightDimension: .fractionalWidth(groupFractionalWidth * 142 / 286))
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 34, leading: 0, bottom: 0, trailing: 0)
        
        let headerSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let header: NSCollectionLayoutBoundarySupplementaryItem = .init(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}
