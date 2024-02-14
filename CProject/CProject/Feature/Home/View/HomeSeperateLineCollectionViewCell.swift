//
//  HomeSeperateLineCollectionViewCell.swift
//  CProject
//
//  Created by Choi Oliver on 2/14/24.
//

import UIKit

struct HomeSeperateLineCollectionViewCellViewModel: Hashable {
    let id: Int
}

class HomeSeperateLineCollectionViewCell: UICollectionViewCell { 
    static let identifier: String = "HomeSeperateLineCollectionViewCell"
    
    func setViewModel(_ viewModel: HomeSeperateLineCollectionViewCellViewModel) {
        contentView.backgroundColor = CPColor.gray0
    }
}

extension HomeSeperateLineCollectionViewCell {
    static func seperateLineLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(11))
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
}
