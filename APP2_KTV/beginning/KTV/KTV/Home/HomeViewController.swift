//
//  HomeViewController.swift
//  KTV
//
//  Created by MacBook on 2023/11/08.
//

import UIKit

class HomeViewController: UIViewController {

    private let homeViewModel: HomeViewModel = .init()
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpTableView()
        self.bindViewModel()
        
        self.homeViewModel.requestData()
    }
    
    private func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(
            UINib(nibName: HomeHeaderCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeHeaderCell.identifier
        )
        self.tableView.register(
            UINib(nibName: HomeVideoCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeVideoCell.identifier
        )
        self.tableView.register(
            UINib(nibName: HomeRecommendContainerCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRecommendContainerCell.identifier
        )
        self.tableView.register(
            UINib(nibName: HomeRankingContainerCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRankingContainerCell.identifier
        )
        self.tableView.register(
            UINib(nibName: HomeRecentWatchContainerCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRecentWatchContainerCell.identifier
        )
        self.tableView.register(
            UINib(nibName: HomeFooterCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeFooterCell.identifier
        )
    }
    
    private func bindViewModel() {
        self.homeViewModel.dataChanged = { [weak self] in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        HomeSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = HomeSection(rawValue: section) else { return 0 }
        
        switch section {
        case .header:
            return 1
        case .video:
            return self.homeViewModel.home?.videos.count ?? 0
        case .recommend:
            return 1
        case .ranking:
            return 1
        case .recentWatch:
            return 1
        case .footer:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = HomeSection(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .header:
            return HomeHeaderCell.height
        case .video:
            return HomeVideoCell.height
        case .recommend:
            return HomeRecommendContainerCell.height
        case .ranking:
            return HomeRankingContainerCell.height
        case .recentWatch:
            return HomeRecentWatchContainerCell.height
        case .footer:
            return HomeFooterCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .header:
            return tableView.dequeueReusableCell(withIdentifier: HomeHeaderCell.identifier, for: indexPath)
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeVideoCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeVideoCell,
               let data = self.homeViewModel.home?.videos[indexPath.item] {
                cell.setData(data)
            }
            
            return cell
        case .recommend:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecommendContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRecommendContainerCell,
               let data = self.homeViewModel.home?.recommends {
                cell.delegate = self
                cell.setData(data)
            }
            
            return cell
        case .ranking:
            let cell =  tableView.dequeueReusableCell(withIdentifier: HomeRankingContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRankingContainerCell,
               let data = self.homeViewModel.home?.rankings {
                cell.delegate = self
                cell.setData(data)
            }
            
            return cell
        case .recentWatch:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecentWatchContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRecentWatchContainerCell,
               let data = self.homeViewModel.home?.recents {
                cell.delegate = self
                cell.setData(data)
            }
            
            return cell
        case .footer:
            return tableView.dequeueReusableCell(withIdentifier: HomeFooterCell.identifier, for: indexPath)
        }
    }
}

extension HomeViewController: HomeRecommendContainerCellDelegate {
    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int) {
        print("home recommend did select at \(index)")
    }
}

extension HomeViewController: HomeRankingContainerCellDelegate {
    func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int) {
        print("home ranking did select at \(index)")
    }
}

extension HomeViewController: HomeRecentWatchContainerCellDelegate {
    func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int) {
        print("home recent watch did select at \(index)")
    }
}
