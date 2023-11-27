//
//  VideoViewController.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/14.
//

import UIKit
import AVKit

protocol VideoViewControllerDelegate: AnyObject {
    func videoViewController(
        _ videoViewController: VideoViewController,
        yPositionForMinimizeView height: CGFloat
    ) -> CGFloat
    
    func videoViewControllerDidMinimize(_ videoViewController: VideoViewController)
    func videoViewControllerNeesdMaximize(_ videoViewController: VideoViewController)
    func videoViewControllerDidTapClose(_ videoViewController: VideoViewController)
}

class VideoViewController: UIViewController {
    private let chattingHiddenBottomConstraint: CGFloat = -500

    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet var playerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - 제어 패널
    @IBOutlet weak var portraitControlPanel: UIView!
    @IBOutlet weak var landscapeControlPanel: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var landscapePlayBtn: UIButton!
    @IBOutlet weak var landscapeTitleLabel: UILabel!
    @IBOutlet weak var landscapePlayTimeLabel: UILabel!
    @IBOutlet weak var seekbarView: SeekbarView!
    
    // MARK: - 최소화
    private var isMinimizeMode: Bool = false {
        didSet {
            self.minimizeView.isHidden = !self.isMinimizeMode
        }
    }
    @IBOutlet weak var minimizeBottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var minimizeView: UIView!
    @IBOutlet weak var minimizePlayerView: PlayerView!
    @IBOutlet weak var minimizePlayBtn: UIButton!
    @IBOutlet weak var minimizeTitleLabel: UILabel!
    @IBOutlet weak var minimizeChannelLabel: UILabel!
    
    // MARK: - chat
    var isLiveMode: Bool = false
    
    @IBOutlet weak var chattingView: ChattingView!
    @IBOutlet weak var chattingViewBottomConstraint: NSLayoutConstraint!
    
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
    private var videoViewModel: VideoViewModel = .init()
    private var isControlPanelHidden: Bool = true {
        didSet {
            if self.isLandscape(size: self.view.frame.size) {
                self.landscapeControlPanel.isHidden = self.isControlPanelHidden
            } else {
                self.portraitControlPanel.isHidden = self.isControlPanelHidden
            }
        }
    }
    
    private var pipController: AVPictureInPictureController?
    weak var delegate: VideoViewControllerDelegate?
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        return formatter
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isBeingPresented {
            self.setupPIPController()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isBeingDismissed {
            self.pipController = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerView.delegate = self
        self.minimizePlayerView.delegate = self
        self.seekbarView.delegate = self
        self.chattingView.delegate = self

        self.channelThumbnailImageView.layer.cornerRadius = 14
        self.setupRecommendTableView()
        
        self.bindViewModel()
        self.videoViewModel.request()
        self.chattingView.isHidden = !self.isLiveMode
        
        self.setupPIPController()
    }
    
    
    // device 회전 감지
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        self.switchControlPanel(size: size)
        self.playerViewBottomConstraint.isActive = self.isLandscape(size: size)
        
        self.chattingView.textField.resignFirstResponder()
        if self.isLandscape(size: size) {
            self.chattingViewBottomConstraint.constant = self.chattingHiddenBottomConstraint
        } else {
            self.chattingViewBottomConstraint.constant = 0
        }
        
        coordinator.animate { _ in
            self.chattingView.collectionView.collectionViewLayout.invalidateLayout()
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func setupPIPController() {
        guard
            AVPictureInPictureController.isPictureInPictureSupported(),
            let playerLayer = self.playerView.avPlayerLayer
        else {
            return
        }
        
        let pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.canStartPictureInPictureAutomaticallyFromInline = true
        
        self.pipController = pipController
    }
    
    private func isLandscape(size: CGSize) -> Bool {
        size.width > size.height
    }
    
    private func bindViewModel() {
        self.videoViewModel.dataChanged = { [weak self] videoData in
            guard let self else { return }
            
            self.setupData(videoData)
        }
    }
    
    private func setupData(_ video: Video) {
        self.playerView.set(url: video.videoURL)
        self.playerView.play()
        self.titleLabel.text = video.title
        self.minimizeTitleLabel.text = video.title
        self.minimizeChannelLabel.text = video.channel
        self.landscapeTitleLabel.text = video.title
        self.channelThumbnailImageView.loadImage(url: video.channelImageUrl)
        self.channelNameLabel.text = video.channel
        self.updateDateLabel.text = Self.dateFormatter.string(from: Date(timeIntervalSince1970: video.uploadTimestamp))
        self.playCountLabel.text = "재생수 \(video.playCount)"
        self.favoriteBtn.setTitle("\(video.favoriteCount)", for: .normal)
        
        self.recommendTableView.reloadData()
    }
    
    @IBAction func commentDidTap(_ sender: Any) {
        guard self.isLiveMode else { return }
        
        self.chattingView.isHidden = false
    }
    
    private func updatePlayButton(isPlaying: Bool) {
        let playImage = UIImage(named: isPlaying ? "small_pause" : "small_play")
        self.playBtn.setImage(playImage, for: .normal)
        self.minimizePlayBtn.setImage(playImage, for: .normal)
        
        let landscapePlayImage = UIImage(named: isPlaying ? "big_pause" : "big_play")
        self.landscapePlayBtn.setImage(landscapePlayImage, for: .normal)
    }
}

extension VideoViewController {
    @IBAction func minimizeViewCloseDidTap(_ sender: Any) {
        self.delegate?.videoViewControllerDidTapClose(self)
    }
    
    @IBAction func maximize(_ sender: Any) {
        self.delegate?.videoViewControllerNeesdMaximize(self)
    }
}

// MARK: - 컨트롤 패널
extension VideoViewController {
    private func switchControlPanel(size: CGSize) {
        guard self.isControlPanelHidden == false else { return }
        
        self.landscapeControlPanel.isHidden = !self.isLandscape(size: size)
        self.portraitControlPanel.isHidden = self.isLandscape(size: size)
    }
    
    @IBAction func toggleControlPanel(_ sender: Any) {
        self.isControlPanelHidden.toggle()
    }
    
    @IBAction func closeDidTap(_ sender: Any) {
        self.isMinimizeMode = true
        self.rotateScene(landscape: false)
        self.dismiss(animated: true)
    }
    
    @IBAction func rewindDidTap(_ sender: Any) {
        self.playerView.rewind()
    }
    
    @IBAction func playDidTap(_ sender: Any) {
        if self.playerView.isPlaying {
            self.playerView.pause()
        } else {
            self.playerView.play()
        }
        
        self.updatePlayButton(isPlaying: self.playerView.isPlaying)
    }
    
    @IBAction func fastForwardDidTap(_ sender: Any) {
        self.playerView.forward()
    }
    
    @IBAction func expandDidTap(_ sender: Any) {
        self.rotateScene(landscape: true)
    }
    
    @IBAction func shrinkDidTap(_ sender: Any) {
        self.rotateScene(landscape: false)
    }
    
    @IBAction func moreDidTap(_ sender: Any) {
        let vc = MoreViewController()
        
        self.present(vc, animated: true)
    }
}

// MARK: - 플레이어 delegate
extension VideoViewController: PlayerViewDelegate {
    func playerViewReadyToPlay(_ playerView: PlayerView) {
        self.seekbarView.setTotalPlayTime(playerView.totalPlayTime)
        self.updatePlayButton(isPlaying: playerView.isPlaying)
        
        self.updatePlayTime(0, totalPlayTime: playerView.totalPlayTime)
    }
    
    func playerView(_ playerView: PlayerView, didPlay playTime: Double, playableTime: Double) {
        self.seekbarView.setPlayTime(playTime, playableTime: playableTime)
        self.updatePlayTime(playTime, totalPlayTime: playerView.totalPlayTime)
    }
    
    func playerViewFinishToPlay(_ playerView: PlayerView) {
        self.playerView.seek(to: 0)
        self.updatePlayButton(isPlaying: false)
    }
    
    private func updatePlayTime(_ playTime: Double, totalPlayTime: Double) {
        guard
            let playTimeText = DateComponentsFormatter.playTimeFormatter.string(from: playTime),
            let totalPlayTimeText = DateComponentsFormatter.playTimeFormatter.string(from: totalPlayTime)
        else {
            self.landscapePlayTimeLabel.text = nil
            return
        }
            
        self.landscapePlayTimeLabel.text = "\(playTimeText) / \(totalPlayTimeText)"
    }
    
    private func rotateScene(landscape: Bool) {
        if #available(iOS 16.0, *) {
            self.view.window?.windowScene?.requestGeometryUpdate(
                .iOS(interfaceOrientations: landscape ? .landscapeRight : .portrait)
            )
        } else {
            let orientation: UIInterfaceOrientation = landscape ? .landscapeRight : .portrait
            
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

extension VideoViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
}

extension VideoViewController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.isBeingPresented {
            guard let view = transitionContext.view(forKey: .to) else { return }
            
            transitionContext.containerView.addSubview(view)
            if self.isMinimizeMode {
                self.chattingViewBottomConstraint.constant = 0
                self.playerViewBottomConstraint.isActive = false
                self.playerView.isHidden = false
                self.minimizeBottomViewConstraint.isActive = false
                self.isMinimizeMode = false
                
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext),
                    animations: {
                        view.frame = .init(
                            origin: CGPoint(x: 0, y: view.safeAreaInsets.top),
                            size: view.window?.frame.size ?? view.frame.size
                        )
                    },
                    completion: { _ in
                        view.frame.origin = .zero
                        transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                    }
                )
            } else {
                view.alpha = 0
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext),
                    animations: {
                        view.alpha = 1
                        view.frame = .init(
                            origin: CGPoint(x: 0, y: view.safeAreaInsets.top),
                            size: view.window?.frame.size ?? view.frame.size
                        )
                    },
                    completion: { _ in
                        transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                    }
                )
            }
        } else {
            guard let view = transitionContext.view(forKey: .from) else { return }
            
            if self.isMinimizeMode,
               let yPosition = self.delegate?.videoViewController(self, yPositionForMinimizeView: self.minimizeView.frame.height) {
                
                self.minimizePlayerView.player = self.playerView.player
                self.isControlPanelHidden = true
                self.chattingViewBottomConstraint.constant = self.chattingHiddenBottomConstraint
                self.playerViewBottomConstraint.isActive = true
                self.playerView.isHidden = true
                
                view.frame.origin.y = view.safeAreaInsets.top
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext),
                    animations: {
                        view.frame.origin.y = yPosition
                        view.frame.size.height = self.minimizeView.frame.height
                    },
                    completion: { _ in
                        transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                        self.minimizeBottomViewConstraint.isActive = true
                        self.delegate?.videoViewControllerDidMinimize(self)
                    }
                )
            } else {
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext),
                    animations: {
                        view.alpha = 0
                    },
                    completion: { _ in
                        transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                        view.alpha = 1
                    }
                )
            }
        }
    }
}

// MARK: - 영상 시간 설정 바 delegate
extension VideoViewController: SeekbarViewDelegate {
    func seekbar(_ seekbar: SeekbarView, seekToPercent percent: Double) {
        self.playerView.seek(to: percent)
    }
}

extension VideoViewController: ChattingViewDelegate {
    func liveChattingViewCloseDidTap(_ chattingView: ChattingView) {
//        self.setEditing(false, animated: true)
        self.chattingView.isHidden = true
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
        self.videoViewModel.video?.recommends.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoListItemCell.identifier, for: indexPath)
        
        if let cell = cell as? VideoListItemCell,
           let data = self.videoViewModel.video?.recommends[indexPath.row] {
            cell.setData(data, rank: indexPath.row + 1)
        }
        
        return cell
    }
}
