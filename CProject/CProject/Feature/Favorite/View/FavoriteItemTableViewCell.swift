//
//  FavoriteItemTableViewCell.swift
//  CProject
//
//  Created by Choi Oliver on 2/15/24.
//

import UIKit
import Kingfisher

struct FavoriteItemTableViewCellViewModel: Hashable {
    let imageUrlString: String
    let productName: String
    let productPrice: String
}

final class FavoriteItemTableViewCell: UITableViewCell {
    static let identifier: String = "FavoriteItemTableViewCell"

    @IBOutlet private weak var productItemImageView: UIImageView!
    @IBOutlet private weak var productTitleLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var productPurchaseButton: PurchaseButton!
    
    //    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    func setViewModel(_ viewModel: FavoriteItemTableViewCellViewModel) {
        productItemImageView.kf.setImage(with: URL(string: viewModel.imageUrlString))
        productTitleLabel.text = viewModel.productName
        productPriceLabel.text = viewModel.productPrice
    }
    
    override func prepareForReuse() {
        productItemImageView.kf.cancelDownloadTask()
    }
}
