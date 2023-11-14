//
//  NavigationController.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/14.
//

import UIKit

class NavigationController: UINavigationController {

    override var childForStatusBarStyle: UIViewController? {
        self.topViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
