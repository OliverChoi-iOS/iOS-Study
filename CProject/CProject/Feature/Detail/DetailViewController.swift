//
//  DetailViewController.swift
//  CProject
//
//  Created by Choi Oliver on 2/15/24.
//

import UIKit
import SwiftUI
import Combine

final class DetailViewController: UIViewController {
    let viewModel: DetailViewModel = .init()
    lazy var rootView: UIHostingController = .init(rootView: DetailRootView(viewModel: self.viewModel))
    private var cancellable: Set<AnyCancellable> = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRootView()
        bindViewModelAction()
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
    
    private func bindViewModelAction() {
        viewModel.showOptionViewController
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                
                let viewController: OptionViewController = .init()
                navigationController?.pushViewController(viewController, animated: true)
            }.store(in: &cancellable)
        
        viewModel.showPurchaseViewController
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                
                let viewController: PurchaseViewController = .init()
                navigationController?.pushViewController(viewController, animated: true)
            }.store(in: &cancellable)
    }
}
