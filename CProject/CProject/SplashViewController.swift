//
//  SplashViewController.swift
//  CProject
//
//  Created by Choi Oliver on 1/16/24.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var appIconCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var appIconCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var appIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        appIconCenterXConstraint.constant = -(view.frame.width / 2) - (appIcon.frame.width / 2)
        appIconCenterYConstraint.constant = -(view.frame.height / 2) - (appIcon.frame.height / 2)

        UIView.animate(withDuration: 1) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
//        UIView.animate(withDuration: 3, animations: { [weak self] in
//            let rotationAngle: CGFloat = CGFloat.pi
//            self?.appIcon.transform = CGAffineTransform(rotationAngle: rotationAngle)
//        })
    }
}
