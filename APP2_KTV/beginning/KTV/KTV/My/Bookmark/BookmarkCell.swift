//
//  BookmarkCell.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/14.
//

import UIKit

class BookmarkCell: UITableViewCell {
    static let identifier: String = "BookmarkCell"
    static let height: CGFloat = 58

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var channelThumbnailView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    private var thumbnailTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.channelThumbnailView.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.thumbnailTask?.cancel()
        self.thumbnailTask = nil
        self.channelThumbnailView.image = nil
        self.channelTitleLabel.text = nil
    }
    
    func setData(_ data: Bookmark.Item) {
        self.channelTitleLabel.text = data.channel
        self.thumbnailTask = self.channelThumbnailView.loadImage(url: data.thumbnail)
    }
}
