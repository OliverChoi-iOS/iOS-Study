//
//  FavoriteViewController.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/14.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    @IBOutlet weak var tableView: UITableView!
    private var favoriteViewModel: FavoriteViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTableView()
        self.bindViewModel()
        
        self.favoriteViewModel.requestData()
    }

    private func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(
            UINib(nibName: VideoListItemCell.identifier, bundle: nil),
            forCellReuseIdentifier: VideoListItemCell.identifier
        )
    }
    
    private func bindViewModel() {
        self.favoriteViewModel.dataChanged = { [weak self] in
            guard let self else { return }
            
            self.tableView.reloadData()
        }
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.favoriteViewModel.favorite?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        VideoListItemCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoListItemCell.identifier, for: indexPath)
        
        if let cell = cell as? VideoListItemCell,
           let data = self.favoriteViewModel.favorite?.list[indexPath.row] {
            cell.setData(data)
            cell.setHorizontalPadding(21)
        }
        
        return cell
    }
    
    
}
