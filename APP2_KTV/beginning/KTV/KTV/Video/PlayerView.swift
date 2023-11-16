//
//  PlayerView.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/16.
//

import UIKit
import AVFoundation

protocol PlayerViewDelegate: AnyObject {
    func playerViewReadyToPlay(_ playerView: PlayerView)
    func playerView(_ playerView: PlayerView, didPlay playTime: Double, playableTime: Double)
    func playerViewFinishToPlay(_ playerView: PlayerView)
}

class PlayerView: UIView {
//    let avPlayerLayer: AVPlayerLayer = AVPlayerLayer()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        self.layer.addSublayer(avPlayerLayer)
//        self.avPlayerLayer.frame = self.bounds
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//
//        self.layer.addSublayer(avPlayerLayer)
//        self.avPlayerLayer.frame = self.bounds
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.avPlayerLayer.frame = self.bounds
//    }
    
    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    private var playObservation: Any?
    private var statusObservation: NSKeyValueObservation?
    
    weak var delegate: PlayerViewDelegate?
    var avPlayerLayer: AVPlayerLayer? {
        self.layer as? AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            self.avPlayerLayer?.player
        }
        set {
            if let oldPlayer = self.avPlayerLayer?.player {
                self.unsetPlayer(oldPlayer)
            }
            
            self.avPlayerLayer?.player = newValue
            
            if let player = newValue {
                self.setup(player: player)
            }
        }
    }
    
    var isPlaying: Bool {
        guard let player else { return false }
        
        return player.rate != 0 // 멈춰있으면 rate가 0
    }
    
    var totalPlayTime: Double {
        self.player?.currentItem?.duration.seconds ?? 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupNotification()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupNotification()
    }
    
    func set(url: URL) {
        self.player = AVPlayer(
            playerItem: AVPlayerItem(
                asset: AVURLAsset(url: url)
            )
        )
    }
    
    func play() {
        self.player?.play()
    }
    
    func pause() {
        self.player?.pause()
    }
    
    func seek(to percent: Double) {
        self.player?.seek(
            to: CMTime(seconds: percent * self.totalPlayTime, preferredTimescale: 1)
        )
    }
    
    func forward(to seconds: Double = 10) {
        guard let currentTime = self.player?.currentItem?.currentTime().seconds else { return }
        
        self.player?.seek(
            to: CMTime(seconds: currentTime + seconds, preferredTimescale: 1)
        )
    }
    
    func rewind(to seconds: Double = 10) {
        guard let currentTime = self.player?.currentItem?.currentTime().seconds else { return }
        
        self.player?.seek(
            to: CMTime(seconds: currentTime - seconds, preferredTimescale: 1)
        )
    }
}

extension PlayerView {
    private func setup(player: AVPlayer) {
        self.playObservation = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 10),
            queue: .main,
            using: { [weak self, weak player] time in
                guard let self else { return }
                
                guard
                    let currentItem = player?.currentItem,
                    currentItem.status == .readyToPlay,
                    let timeRange = (currentItem.loadedTimeRanges as? [CMTimeRange])?.first
                else {
                    return
                }
                
                let playableTime = timeRange.start.seconds + timeRange.duration.seconds
                let playTime = time.seconds
                
                self.delegate?.playerView(self, didPlay: playTime, playableTime: playableTime)
            }
        )
        
        self.statusObservation = player.currentItem?.observe(
            \.status,
             changeHandler: { [weak self] item, _ in
                 guard let self else { return }
                 
                 switch item.status {
                 case .readyToPlay:
                     self.delegate?.playerViewReadyToPlay(self)
                 case .failed, .unknown:
                     print("‼️ failed to play \(item.error?.localizedDescription ?? "")")
                 @unknown default:
                     print("‼️ failed to play \(item.error?.localizedDescription ?? "")")
                 }
             }
        )
    }
    
    private func unsetPlayer(_ player: AVPlayer) {
        self.statusObservation?.invalidate()
        self.statusObservation = nil
        
        if let playObservation {
            player.removeTimeObserver(playObservation)
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didPlayToEnd(_:)),
            name: AVPlayerItem.didPlayToEndTimeNotification,
            object: nil
        )
    }
    
    @objc private func didPlayToEnd(_ notification: Notification) {
        self.delegate?.playerViewFinishToPlay(self)
    }
}
