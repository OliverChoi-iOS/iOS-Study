//
//  HomeRecentWatchContainerCell.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/13.
//

import UIKit

protocol HomeRecentWatchContainerCellDelegate: AnyObject {
    func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int)
}

class HomeRecentWatchContainerCell: UICollectionViewCell {
    static let identifier: String = "HomeRecentWatchContainerCell"
    static let height: CGFloat = 207

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: HomeRecentWatchContainerCellDelegate?
    private var recents: [Home.Recent]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.layer.cornerRadius = 10
        self.collectionView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
        self.collectionView.layer.borderWidth = 1
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(
            UINib(nibName: HomeRecentWatchItemCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRecentWatchItemCell.identifier
        )
    }

    func setData(_ data: [Home.Recent]) {
        self.recents = data
        self.collectionView.reloadData()
    }
    
}

extension HomeRecentWatchContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.recents?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRecentWatchItemCell.identifier, for: indexPath)
        
        if let cell = cell as? HomeRecentWatchItemCell,
           let data = self.recents?[indexPath.item] {
            cell.setData(data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.homeRecentWatchContainerCell(self, didSelectItemAt: indexPath.item)
    }
}
