//
//  MyViewController.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/14.
//

import UIKit

class MyViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userImageView.layer.cornerRadius = 5
    }

}
