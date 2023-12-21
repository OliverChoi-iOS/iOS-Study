//
//  KeyboardToolbar.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import SwiftUI

struct KeyboardToolbar<ToolbarView: View>: ViewModifier {
    private let height: CGFloat
    private let toolBarView: ToolbarView
    
    init(
        height: CGFloat,
        @ViewBuilder toolBarView: () -> ToolbarView
    ) {
        self.height = height
        self.toolBarView = toolBarView()
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            GeometryReader(content: { proxy in
                content
                    .frame(width: proxy.size.width, height: proxy.size.height - height)
            })
            
            toolBarView
                .frame(height: height)
        }
    }
}

extension View {
    func keyboardToolbar<ToolbarView>(
        height: CGFloat,
        view: @escaping () -> ToolbarView
    ) -> some View where ToolbarView: View {
        self.modifier(KeyboardToolbar(height: height, toolBarView: view))
    }
}
