//
//  HomeRecommendItemCell.swift
//  KTV
//
//  Created by MacBook on 2023/11/09.
//

import UIKit

class HomeRecommendItemCell: UITableViewCell {
    static let identifier: String = "HomeRecommendItemCell"
    static let height: CGFloat = 72
    
    @IBOutlet weak var thumbnailContainerView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var playTimeBgView: UIView!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnailContainerView.layer.cornerRadius = 5
        
        self.numberLabel.layer.cornerRadius = 5
        self.numberLabel.clipsToBounds = true
        
        self.playTimeBgView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
