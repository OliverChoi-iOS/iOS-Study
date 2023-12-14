//
//  TabBarController.swift
//  KTV
//
//  Created by MacBook on 2023/11/08.
//

import UIKit

class TabBarController: UITabBarController, VideoViewControllerContainer, VideoViewControllerDelegate {
    weak var videoViewController: VideoViewController?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func videoViewController(_ videoViewController: VideoViewController, yPositionForMinimizeView height: CGFloat) -> CGFloat {
        return self.tabBar.frame.minY - height
    }
    
    func videoViewControllerDidMinimize(_ videoViewController: VideoViewController) {
        self.videoViewController = videoViewController
        self.addChild(videoViewController)
        self.view.addSubview(videoViewController.view)
        // auto layout
        videoViewController.didMove(toParent: self)
    }
    
    func videoViewControllerNeesdMaximize(_ videoViewController: VideoViewController) {
        self.videoViewController = nil
        videoViewController.willMove(toParent: nil)
        videoViewController.view.removeFromSuperview()
        videoViewController.removeFromParent()
        
        self.present(videoViewController, animated: true)
    }
    
    func videoViewControllerDidTapClose(_ videoViewController: VideoViewController) {
        videoViewController.willMove(toParent: nil)
        videoViewController.view.removeFromSuperview()
        videoViewController.removeFromParent()
        
        self.videoViewController = nil
    }
    
    func presentCurrentViewController() {
        guard let videoViewController else { return }

        videoViewController.willMove(toParent: nil)
        videoViewController.view.removeFromSuperview()
        videoViewController.removeFromParent()
        
        self.present(videoViewController, animated: true)
        self.videoViewController = nil
    }
}
