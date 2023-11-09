//
//  HomeRecommendContainerCell.swift
//  KTV
//
//  Created by MacBook on 2023/11/09.
//

import UIKit

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
}

extension HomeRecommendContainerCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: HomeRecommendItemCell.identifier, for: indexPath)
    }
}
