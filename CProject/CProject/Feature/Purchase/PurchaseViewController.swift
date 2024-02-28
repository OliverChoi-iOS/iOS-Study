//
//  PurchaseViewController.swift
//  CProject
//
//  Created by Choi Oliver on 2/19/24.
//

import UIKit
import Combine

final class PurchaseViewController: UIViewController {
    private var viewModel: PurchaseViewModel = .init()
    private var rootView: PurchaseRootView = .init()
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        bindViewModel()
        viewModel.process(action: .loadData)
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self, let purchaseItems = viewModel.state.purchaseItems else { return }
                rootView.setPurchaseItem(purchaseItems)
            }.store(in: &cancellable)
        
        viewModel.showPaymentViewController
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                let paymentViewController: PaymentViewController = .init()
                navigationController?.pushViewController(paymentViewController, animated: true)
            }.store(in: &cancellable)
    }
}

#Preview {
    PurchaseViewController()
}
