//
//  HomeRecentWatchItemCell.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/13.
//

import UIKit

class HomeRecentWatchItemCell: UICollectionViewCell {
    static let identifier: String = "HomeRecentWatchItemCell"

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbnailContainerView: UIView!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var watchDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    private var thumbnailTask: Task<Void, Never>?
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMDD."
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnailContainerView.layer.cornerRadius = 42
        self.thumbnailContainerView.layer.borderWidth = 2
        self.thumbnailContainerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
        self.thumbnailContainerView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.thumbnailTask?.cancel()
        self.thumbnailTask = nil
        self.watchDateLabel.text = nil
        self.titleLabel.text = nil
        self.subtitleLabel.text = nil
    }

    func setData(_ data: Home.Recent) {
        let watchDate = Date.init(timeIntervalSince1970: data.timeStamp)
        self.watchDateLabel.text = HomeRecentWatchItemCell.dateFormatter.string(from: watchDate)
        self.titleLabel.text = data.title
        self.subtitleLabel.text = data.channel
        
        self.thumbnailTask = self.thumbnailView.loadImage(url: data.imageUrl)
    }
}
