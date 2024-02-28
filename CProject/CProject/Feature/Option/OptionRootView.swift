//
//  OptionRootView.swift
//  CProject
//
//  Created by Choi Oliver on 2/15/24.
//

import SwiftUI

struct OptionRootView: View {
    
    @StateObject var viewModel: OptionViewModel
    
    var body: some View {
        Text("Option View")
    }
}

#Preview {
    OptionRootView(viewModel: .init())
}
