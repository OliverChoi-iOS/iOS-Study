//
//  HomeRankingItemCell.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/13.
//

import UIKit

class HomeRankingItemCell: UICollectionViewCell {
    static let identifier: String = "HomeRankingItemCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var rankNumberLabel: UILabel!
    private var thumbnailTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.containerView.layer.cornerRadius = 10
        self.containerView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.rankNumberLabel.text = nil
        self.thumbnailView.image = nil
        self.thumbnailTask?.cancel()
        self.thumbnailTask = nil
    }
    
    func setData(_ data: Home.Ranking, rank: Int) {
        self.rankNumberLabel.text = "\(rank)"
        self.thumbnailTask = self.thumbnailView.loadImage(url: data.imageUrl)
    }
}
