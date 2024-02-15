//
//  CPImages.swift
//  CProject
//
//  Created by Choi Oliver on 1/16/24.
//

import UIKit
import SwiftUI

enum CPImage { }

extension CPImage {
    enum UIKit {
        static var buttonComplete: UIImage = .init(resource: .btnComplete)
        static var buttonActivate: UIImage = .init(resource: .btnActivate)
        
        static var topBtn: UIImage = .init(resource: .topBtn)
        static var home: UIImage = .init(resource: .home)
        static var left: UIImage = .init(resource: .left)
        static var next: UIImage = .init(resource: .next)
        static var down: UIImage = .init(resource: .down)
        static var close: UIImage = UIImage(resource: .close)
        
        // favorite
        static var favoriteOn: UIImage = .init(resource: .favoriteOn)
        static var favoriteOff: UIImage = .init(resource: .favoriteOff)
        
        // categories
        static var category1Big: UIImage = .init(resource: .category1Big)
        static var category1Small: UIImage = .init(resource: .category1Small)
        static var category2Big: UIImage = .init(resource: .category2Big)
        static var category2Small: UIImage = .init(resource: .category2Small)
        static var category3Big: UIImage = .init(resource: .category3Big)
        static var category3Small: UIImage = .init(resource: .category3Small)
        static var category4Big: UIImage = .init(resource: .category4Big)
        static var category4Small: UIImage = .init(resource: .category4Small)
        static var category5Big: UIImage = .init(resource: .category5Big)
        static var category5Small: UIImage = .init(resource: .category5Small)
        static var category6Big: UIImage = .init(resource: .category6Big)
        static var category6Small: UIImage = .init(resource: .category6Small)
        static var category7Big: UIImage = .init(resource: .category7Big)
        static var category7Small: UIImage = .init(resource: .category7Small)
        static var category8Big: UIImage = .init(resource: .category8Big)
        static var category8Small: UIImage = .init(resource: .category8Small)
    }
}

extension CPImage {
    enum SwiftUI {
        static var buttonComplete: Image = .init(.btnComplete)
        static var buttonActivate: Image = .init(.btnActivate)
        
        static var topBtn: Image = .init(.topBtn)
        static var home: Image = .init(.home)
        static var left: Image = .init(.left)
        static var next: Image = .init(.next)
        static var down: Image = .init(.down)
        static var close: Image = .init(.close)
        
        // favorite
        static var favoriteOn: Image = .init(.favoriteOn)
        static var favoriteOff: Image = .init(.favoriteOff)
        
        // categories
        static var category1Big: Image = .init(.category1Big)
        static var category1Small: Image = .init(.category1Small)
        static var category2Big: Image = .init(.category2Big)
        static var category2Small: Image = .init(.category2Small)
        static var category3Big: Image = .init(.category3Big)
        static var category3Small: Image = .init(.category3Small)
        static var category4Big: Image = .init(.category4Big)
        static var category4Small: Image = .init(.category4Small)
        static var category5Big: Image = .init(.category5Big)
        static var category5Small: Image = .init(.category5Small)
        static var category6Big: Image = .init(.category6Big)
        static var category6Small: Image = .init(.category6Small)
        static var category7Big: Image = .init(.category7Big)
        static var category7Small: Image = .init(.category7Small)
        static var category8Big: Image = .init(.category8Big)
        static var category8Small: Image = .init(.category8Small)
    }
}
