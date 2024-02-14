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
        
        // 1. 가장 단순한 방법: 모달 형태이므로 적절하지 않음 (SplashViewController는 더 이상 필요없기 때문에)
        /*
        present(HomeViewController(), animated: true)
         */
        
        // 2. rootViewController 교체
        // 2.1 iOS 15 이전 버전 호환
        /*
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController = HomeViewController()
        }
         */
        
        // 2.2 iOS 15 이후 사용가능 방법
        /*
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.keyWindow {
            keyWindow.rootViewController = HomeViewController()
        }
         */
        
        // 3. Storyboard 정상 동작을 위한 코드
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.keyWindow {
            keyWindow.rootViewController = viewController
        }
    }
}
