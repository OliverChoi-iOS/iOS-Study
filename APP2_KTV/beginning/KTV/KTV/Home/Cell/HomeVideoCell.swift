//
//  HomeVideoCell.swift
//  KTV
//
//  Created by MacBook on 2023/11/08.
//

import UIKit

class HomeVideoCell: UITableViewCell {
    static let identifier: String = "HomeVideoCell"
    static let height: CGFloat = 320
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var hotImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var channelSubTitleLabel: UILabel!
    
    private var thumbnailTask: Task<Void, Never>?
    private var channelThumbnailTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
        self.containerView.layer.borderWidth = 1
    }

    func setData(_ data: Home.Video) {
        self.titleLabel.text = data.title
        self.subTitleLabel.text = data.subtitle
        self.channelTitleLabel.text = data.channel
        self.channelSubTitleLabel.text = data.channelDescription
        self.hotImageView.isHidden = !data.isHot
        
        self.thumbnailTask = self.thumbnailImageView.loadImage(url: data.imageUrl)
        self.channelThumbnailTask = self.channelImageView.loadImage(url: data.channelThumbnailURL)
    }
}
