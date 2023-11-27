//
//  LiveViewController.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/17.
//

import UIKit

class LiveViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sortByFavoriteBtn: UIButton!
    @IBOutlet weak var sortByStartTimeBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private let viewModel: LiveViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.containerView.layer.cornerRadius = 15
        self.containerView.layer.borderColor = UIColor(named: "gray-2")?.cgColor
        self.containerView.layer.borderWidth = 1
        
        self.setupCollectionView()
        self.bindViewModel()
        
        self.viewModel.request(sort: .favorite)
    }
    
    private func bindViewModel() {
        self.viewModel.dataChanged = { [weak self] items in
            self?.collectionView.reloadData()
            
            if items.isEmpty == false {
//                self?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                self?.collectionView.setContentOffset(.zero, animated: true)
            }
        }
    }

    @IBAction func sortDidTap(_ sender: UIButton) {
        guard sender.isSelected == false else { return }
        
        self.sortByFavoriteBtn.isSelected = sender == self.sortByFavoriteBtn
        self.sortByStartTimeBtn.isSelected = sender == self.sortByStartTimeBtn
        
        if self.sortByFavoriteBtn.isSelected {
            self.viewModel.request(sort: .favorite)
        } else {
            self.viewModel.request(sort: .startTime)
        }
    }
    
    private func setupCollectionView() {
        self.collectionView.register(
            UINib(nibName: LiveCell.identifer, bundle: nil),
            forCellWithReuseIdentifier: LiveCell.identifer
        )
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

extension LiveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: LiveCell.height)
    }
    
    
}

extension LiveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveCell.identifer, for: indexPath)
        
        if let cell = cell as? LiveCell,
           let data = self.viewModel.items?[indexPath.item] {
            cell.setData(data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = (self.tabBarController as? VideoViewControllerContainer)?.videoViewController {
            (self.tabBarController as? VideoViewControllerContainer)?.presentCurrentViewController()
        } else {
            let vc = VideoViewController()
            vc.isLiveMode = true
            vc.delegate = self.tabBarController as? VideoViewControllerDelegate
            
            self.present(vc, animated: true)
        }
    }
}
