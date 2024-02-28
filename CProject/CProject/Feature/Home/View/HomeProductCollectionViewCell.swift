//
//  HomeProductCollectionViewCell.swift
//  CProject
//
//  Created by Choi Oliver on 2/14/24.
//

import UIKit
import Kingfisher

struct HomeProductCollectionViewCellViewModel: Hashable {
    let imageUrlString: String
    let title: String
    let reasonDiscountString: String
    let originalPrice: String
    let discountPrice: String
}

final class HomeProductCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "HomeProductCollectionViewCell"
    
    @IBOutlet private weak var productItemImageView: UIImageView!
    @IBOutlet private weak var productTitleLabel: UILabel!
    @IBOutlet private weak var productReasonDiscountLabel: UILabel!
    @IBOutlet private weak var productOriginalPriceLabel: UILabel!
    @IBOutlet private weak var productDiscountPriceLabel: UILabel!
    
    override func awakeFromNib() {
        productItemImageView.layer.cornerRadius = 5
    }
    
    func setViewModel(_ viewModel: HomeProductCollectionViewCellViewModel) {
        productItemImageView.kf.setImage(with: URL(string: viewModel.imageUrlString))
        productTitleLabel.text = viewModel.title
        productReasonDiscountLabel.text = viewModel.reasonDiscountString
        productOriginalPriceLabel.attributedText = NSMutableAttributedString(
            string: viewModel.originalPrice,
            attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        productDiscountPriceLabel.text = viewModel.discountPrice
    }
    
    override func prepareForReuse() {
        productItemImageView.kf.cancelDownloadTask()
    }
}

extension HomeProductCollectionViewCell {
    static func horizontalProductItemLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .absolute(117), heightDimension: .estimated(224))
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 14
        section.contentInsets = .init(top: 25, leading: 33, bottom: 0, trailing: 33)
        
        return section
    }
    
    static func verticalProductItemLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1 / 2), heightDimension: .estimated(277))
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 2.5, bottom: 0, trailing: 2.5)
        
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(277))
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 20, leading: 19 - 2.5, bottom: 20, trailing: 19 - 2.5)
        section.interGroupSpacing = 10
        
        return section
    }
}
