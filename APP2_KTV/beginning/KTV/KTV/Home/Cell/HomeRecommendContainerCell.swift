//
//  HomeRecommendContainerCell.swift
//  KTV
//
//  Created by MacBook on 2023/11/09.
//

import UIKit

protocol HomeRecommendContainerCellDelegate: AnyObject {
    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int)
}

class HomeRecommendContainerCell: UITableViewCell {
    static let identifier: String = "HomeRecommendContainerCell"
    static var height: CGFloat {
        let top: CGFloat = 84 - 6 // top spacing - cell item padding
        let bottom: CGFloat = 68 - 6 // bottom spacing - cell item padding
        let footerInset: CGFloat = 51 // container cell ~ footer 까지의 여백
        return HomeRecommendItemCell.height * 5 + top + bottom + footerInset
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var recommendTitleView: UILabel!
    @IBOutlet weak var recommendTableView: UITableView!
    @IBOutlet weak var unfoldBtn: UIImageView!
    private var recommends: [Home.Recommend]?
    
    weak var delegate: HomeRecommendContainerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
        self.containerView.layer.borderWidth = 1
        
        self.recommendTableView.rowHeight = HomeRecommendItemCell.height
        self.recommendTableView.delegate = self
        self.recommendTableView.dataSource = self
        
        self.recommendTableView.register(
            UINib(nibName: HomeRecommendItemCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRecommendItemCell.identifier
        )
    }
    
    func setData(_ data: [Home.Recommend]) {
        self.recommends = data
        self.recommendTableView.reloadData()
    }
}

extension HomeRecommendContainerCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.recommends?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecommendItemCell.identifier, for: indexPath)
        
        if let cell = cell as? HomeRecommendItemCell,
           let data = self.recommends?[indexPath.row] {
            cell.setData(data, rank: indexPath.row + 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.homeRecommendContainerCell(self, didSelectItemAt: indexPath.row)
    }
}
