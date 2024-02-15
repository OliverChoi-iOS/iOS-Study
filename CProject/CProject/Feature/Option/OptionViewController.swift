//
//  OptionViewController.swift
//  CProject
//
//  Created by Choi Oliver on 2/15/24.
//

import SwiftUI

final class OptionViewController: UIViewController {
    let viewModel: OptionViewModel = .init()
    lazy var rootView: UIHostingController = .init(rootView: OptionRootView(viewModel: self.viewModel))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRootView()
    }

    private func addRootView() {
        addChild(rootView)
        view.addSubview(rootView.view)
        
        rootView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootView.view.topAnchor.constraint(equalTo: view.topAnchor),
            rootView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
