//
//  HomeRecommendContainerCell.swift
//  KTV
//
//  Created by MacBook on 2023/11/09.
//

import UIKit

protocol HomeRecommendContainerCellDelegate: AnyObject {
    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int)
    func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell)
}

class HomeRecommendContainerCell: UITableViewCell {
    static let identifier: String = "HomeRecommendContainerCell"
    static func height(viewModel: HomeRecommendViewModel) -> CGFloat {
        let top: CGFloat = 84 - 6 // top spacing - cell item padding
        let bottom: CGFloat = 68 - 6 // bottom spacing - cell item padding
        let footerInset: CGFloat = 51 // container cell ~ footer 까지의 여백
        return HomeRecommendItemCell.height * CGFloat(viewModel.itemCount) + top + bottom + footerInset
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var recommendTitleView: UILabel!
    @IBOutlet weak var recommendTableView: UITableView!
    @IBOutlet weak var foldBtn: UIButton!
    
    private var recommends: [Home.Recommend]?
    
    weak var delegate: HomeRecommendContainerCellDelegate?
    private var viewModel: HomeRecommendViewModel?
    
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
    
    @IBAction func foldBtnTapped(_ sender: Any) {
        self.viewModel?.toggleFoldState()
        self.delegate?.homeRecommendContainerCellFoldChanged(self)
    }
    
    func setViewModel(_ viewModel: HomeRecommendViewModel) {
        self.viewModel = viewModel
        self.setButtonImage(viewModel.isFolded)
        self.recommendTableView.reloadData()
        self.viewModel?.foldChanged = { [weak self] isFolded in
            guard let self else { return }
            
            self.recommendTableView.reloadData()
            self.setButtonImage(isFolded)
        }
    }
    
    private func setButtonImage(_ isFolded: Bool) {
        let imageName: String = isFolded ? "unfold" : "fold"
        
        self.foldBtn.setImage(UIImage(named: imageName), for: .normal)
    }
}

extension HomeRecommendContainerCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.recommends?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecommendItemCell.identifier, for: indexPath)
        
        if let cell = cell as? HomeRecommendItemCell,
           let data = self.viewModel?.recommends?[indexPath.row] {
            cell.setData(data, rank: indexPath.row + 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.homeRecommendContainerCell(self, didSelectItemAt: indexPath.row)
    }
}
