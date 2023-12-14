//
//  LiveCell.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/17.
//

import UIKit

class LiveCell: UICollectionViewCell {
    static let identifer: String = "LiveCell"
    static let height: CGFloat = 76

    @IBOutlet weak var LiveLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    private var imageTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.LiveLabel.layer.cornerRadius = 5
        self.LiveLabel.clipsToBounds = true
        self.imageView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageTask?.cancel()
        self.imageTask = nil
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
    }

    func setData(_ data: Live.Item) {
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.channel
        self.imageTask = self.imageView.loadImage(url: data.thumbnailUrl)
    }
}
