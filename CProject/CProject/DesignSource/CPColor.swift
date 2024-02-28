//
//  CPColor.swift
//  CProject
//
//  Created by Choi Oliver on 1/16/24.
//

import SwiftUI

enum CPColor { }

extension CPColor {
    enum UIKit {
        static var bk: UIColor = .init(named: "bk")!
        static var coral: UIColor = .init(named: "coral")!
        static var gray0: UIColor = .init(named: "gray-0")!
        static var gray2: UIColor = .init(named: "gray-2")!
        static var gray3Cool: UIColor = .init(named: "gray-3-cool")!
        static var gray3: UIColor = .init(named: "gray-3")!
        static var gray4: UIColor = .init(named: "gray-4")!
        static var gray5: UIColor = .init(named: "gray-5")!
        static var green: UIColor = .init(named: "green")!
        static var icon: UIColor = .init(named: "icon")!
        static var keyColorBlueTrans: UIColor = .init(named: "key-color-blue-trans")!
        static var keyColorBlue: UIColor = .init(named: "key-color-blue")!
        static var keyColorRed: UIColor = .init(named: "key-color-red")!
        static var keyColorRed2: UIColor = .init(named: "key-color-red-2")!
        static var wh: UIColor = .init(named: "wh")!
        static var yellow: UIColor = .init(named: "yellow")!
    }
}

extension CPColor {
    enum SwiftUI {
        static var bk: Color = .init("bk", bundle: nil)
        static var coral: Color = .init("coral", bundle: nil)
        static var gray0: Color = .init("gray-0", bundle: nil)
        static var gray2: Color = .init("gray-2", bundle: nil)
        static var gray3Cool: Color = .init("gray-3-cool", bundle: nil)
        static var gray3: Color = .init("gray-3", bundle: nil)
        static var gray4: Color = .init("gray-4", bundle: nil)
        static var gray5: Color = .init("gray-5", bundle: nil)
        static var green: Color = .init("green", bundle: nil)
        static var icon: Color = .init("icon", bundle: nil)
        static var keyColorBlueTrans: Color = .init("key-color-blue-trans", bundle: nil)
        static var keyColorBlue: Color = .init("key-color-blue", bundle: nil)
        static var keyColorRed: Color = .init("key-color-red", bundle: nil)
        static var keyColorRed2: Color = .init("key-color-red-2", bundle: nil)
        static var wh: Color = .init("wh", bundle: nil)
        static var yellow: Color = .init("yellow", bundle: nil)
    }
}
