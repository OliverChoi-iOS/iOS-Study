//
//  HomeViewController.swift
//  KTV
//
//  Created by MacBook on 2023/11/08.
//

import UIKit

class HomeViewController: UIViewController {

    private let homeViewModel: HomeViewModel = .init()
    @IBOutlet weak var collectionView: UICollectionView!
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpCollectionView()
        self.bindViewModel()
        
        self.homeViewModel.requestData()
    }
    
    private func setUpCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(
            UINib(nibName: HomeHeaderView.identifier, bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeHeaderView.identifier
        )
        self.collectionView.register(
            UINib(nibName: HomeVideoCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeVideoCell.identifier
        )
        self.collectionView.register(
            UINib(nibName: HomeRecommendContainerCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRecommendContainerCell.identifier
        )
        self.collectionView.register(
            UINib(nibName: HomeRankingContainerCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRankingContainerCell.identifier
        )
        self.collectionView.register(
            UINib(nibName: HomeRecentWatchContainerCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRecentWatchContainerCell.identifier
        )
        self.collectionView.register(
            UINib(nibName: HomeFooterView.identifier, bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: HomeFooterView.identifier
        )
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "empty")
    }
    
    private func bindViewModel() {
        self.homeViewModel.dataChanged = { [weak self] in
            guard let self else { return }
            
            self.collectionView.reloadData()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let section = HomeSection(rawValue: section) else {
            return .zero
        }
        
        switch section {
        case .header:
            return CGSize(width: collectionView.frame.width, height: HomeHeaderView.height)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let section = HomeSection(rawValue: section) else {
            return .zero
        }
        
        switch section {
        case .footer:
            return CGSize(width: collectionView.frame.width, height: HomeFooterView.height)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let section = HomeSection(rawValue: section) else {
            return .zero
        }
        
        return self.insetForSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let section = HomeSection(rawValue: section) else {
            return 0
        }
        switch section {
        case .header, .footer:
            return 0
        default:
            return 21
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return .zero
        }
        
        let inset = self.insetForSection(section)
        let width = collectionView.frame.width - inset.left - inset.right
        
        switch section {
        case .header, .footer:
            return .zero
        case .video:
            return .init(width: width, height: HomeVideoCell.height)
        case .recommend:
            return .init(
                width: width, 
                height: HomeRecommendContainerCell.height(viewModel: self.homeViewModel.recommendViewModel)
            )
        case .ranking:
            return .init(width: width, height: HomeRankingContainerCell.height)
        case .recentWatch:
            return .init(width: width, height: HomeRecentWatchContainerCell.height)
        }
    }
    
    func insetForSection(_ section: HomeSection) -> UIEdgeInsets {
        switch section {
        case .header, .footer:
            return .zero
        default:
            return .init(top: 0, left: 21, bottom: 21, right: 21)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        HomeSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = HomeSection(rawValue: section) else { return 0 }
        
        switch section {
        case .header:
            return 0
        case .video:
            return self.homeViewModel.home?.videos.count ?? 0
        case .recommend:
            return 1
        case .ranking:
            return 1
        case .recentWatch:
            return 1
        case .footer:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }
        
        switch section {
        case .header:
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HomeHeaderView.identifier,
                for: indexPath
            )
        case .footer:
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: HomeFooterView.identifier,
                for: indexPath
            )
        default:
            return .init()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "empty", for: indexPath)
        }
        
        switch section {
        case .header, .footer:
            return collectionView.dequeueReusableCell(withReuseIdentifier: "empty", for: indexPath)
        case .video:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeVideoCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeVideoCell,
               let data = self.homeViewModel.home?.videos[indexPath.item] {
                cell.setData(data)
            }
            
            return cell
        case .recommend:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRecommendContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRecommendContainerCell {
                cell.delegate = self
                cell.setViewModel(self.homeViewModel.recommendViewModel)
            }
            
            return cell
        case .ranking:
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: HomeRankingContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRankingContainerCell,
               let data = self.homeViewModel.home?.rankings {
                cell.delegate = self
                cell.setData(data)
            }
            
            return cell
        case .recentWatch:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRecentWatchContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRecentWatchContainerCell,
               let data = self.homeViewModel.home?.recents {
                cell.delegate = self
                cell.setData(data)
            }
            
            return cell
        }
    }
}

extension HomeViewController: HomeRecommendContainerCellDelegate {
    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int) {
        print("home recommend did select at \(index)")
    }
    
    func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell) {
        self.collectionView.collectionViewLayout.invalidateLayout()
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
