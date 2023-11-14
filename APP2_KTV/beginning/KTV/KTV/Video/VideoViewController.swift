//
//  VideoViewController.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/14.
//

import UIKit

class VideoViewController: UIViewController {

    // MARK: - 제어 패널
    @IBOutlet weak var playBtn: UIButton!
    
    // MARK: - scroll
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var channelThumbnailImageView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    
    @IBOutlet weak var recommendTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    private var contentSizeObservation: NSKeyValueObservation?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.channelThumbnailImageView.layer.cornerRadius = 14
        self.setupRecommendTableView()
    }
    
    @IBAction func commentDidTap(_ sender: Any) {
    }
}

extension VideoViewController {
    @IBAction func toggleControlPanel(_ sender: Any) {
        
    }
    
    @IBAction func closeDidTap(_ sender: Any) {
        
    }
    
    @IBAction func rewindDidTap(_ sender: Any) {
        
    }
    
    @IBAction func playDidTap(_ sender: Any) {
        
    }
    
    @IBAction func fastForwardDidTap(_ sender: Any) {
        
    }
    
    @IBAction func expandDidTap(_ sender: Any) {
        
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupRecommendTableView() {
        self.recommendTableView.delegate = self
        self.recommendTableView.dataSource = self
        self.recommendTableView.rowHeight = VideoListItemCell.height
        self.recommendTableView.register(
            UINib(nibName: VideoListItemCell.identifier, bundle: nil),
            forCellReuseIdentifier: VideoListItemCell.identifier
        )
        
        self.contentSizeObservation = self.recommendTableView.observe(
            \.contentSize,
             changeHandler: { [weak self] tableView, _ in
                 guard let self else { return }
                 
                 self.tableViewHeightConstraint.constant = tableView.contentSize.height
             }
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoListItemCell.identifier, for: indexPath)
        
        return cell
    }
}
