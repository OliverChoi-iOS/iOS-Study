//
//  VideoViewControllerContainer.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/27.
//

import Foundation

protocol VideoViewControllerContainer {
    var videoViewController: VideoViewController? { get }
    func presentCurrentViewController()
}
