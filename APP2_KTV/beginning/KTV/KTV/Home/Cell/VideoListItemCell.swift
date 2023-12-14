//
//  VideoListItemCell.swift
//  KTV
//
//  Created by MacBook on 2023/11/09.
//

import UIKit

class VideoListItemCell: UITableViewCell {
    static let identifier: String = "VideoListItemCell"
    static let height: CGFloat = 72
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var thumbnailContainerView: UIView!
    @IBOutlet weak var rankBgView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var playTimeBgView: UIView!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    private var thumbnailTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnailContainerView.layer.cornerRadius = 5
        
        self.rankBgView.layer.cornerRadius = 5
        self.rankBgView.clipsToBounds = true
        self.rankBgView.isHidden = true
        
        self.playTimeBgView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.thumbnailTask?.cancel()
        self.thumbnailTask = nil
        self.rankBgView.isHidden = true
        self.numberLabel.text = nil
        self.playTimeLabel.text = nil
        self.titleLabel.text = nil
        self.subTitleLabel.text = nil
        
        self.leadingConstraint.constant = 0
        self.trailingConstraint.constant = 0
    }

    func setData(_ data: VideoListItem, rank: Int? = nil) {
        self.rankBgView.isHidden = rank == nil
        if let rank {
            self.numberLabel.text = "\(rank)"
        }
        self.playTimeLabel.text = DateComponentsFormatter.playTimeFormatter.string(from: data.playtime)
        self.titleLabel.text = data.title
        self.subTitleLabel.text = data.channel
        self.thumbnailTask = self.thumbnailImageView.loadImage(url: data.imageUrl)
    }
    
    func setHorizontalPadding(_ padding: CGFloat) {
        self.leadingConstraint.constant = padding
        self.trailingConstraint.constant = padding
    }
}
