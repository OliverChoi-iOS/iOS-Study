//
//  MoreTableViewCell.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/14.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
    static let identifier: String = "MoreTableViewCell"
    static let height: CGFloat = 48

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightTextLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = nil
        self.rightTextLabel.text = nil
    }

    func setData(_ data: MoreItem, isSeperatorHidden: Bool) {
        self.titleLabel.text = data.title
        self.rightTextLabel.text = data.rightText
        self.seperatorView.isHidden = isSeperatorHidden
    }
}
