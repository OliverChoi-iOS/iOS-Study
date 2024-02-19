//
//  PurchaseViewModel.swift
//  CProject
//
//  Created by Choi Oliver on 2/19/24.
//

import Foundation

final class PurchaseViewModel: ObservableObject {
    enum Action {
        case loadData
        
        case didTapPurchaseButton
    }
    
    struct State {
        var purchaseItems: [PurchaseSelectedItemViewModel]?
    }
    
    @Published private(set) var state: State = .init()
    
    func process(action: Action) {
        switch action {
        case .loadData:
            Task { await loadData() }
        case .didTapPurchaseButton:
            Task { await didTapPurchaseButton() }
        }
    }
}

extension PurchaseViewModel {
    @MainActor
    private func loadData() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            
            state.purchaseItems = [
                .init(title: "PlayStation1", description: "수량 1개 / 무료배송"),
                .init(title: "PlayStation2", description: "수량 1개 / 무료배송"),
                .init(title: "PlayStation3", description: "수량 1개 / 무료배송"),
                .init(title: "PlayStation4", description: "수량 1개 / 무료배송"),
                .init(title: "PlayStation5", description: "수량 1개 / 무료배송"),
                .init(title: "PlayStation6", description: "수량 1개 / 무료배송"),
                .init(title: "PlayStation7", description: "수량 1개 / 무료배송"),
                .init(title: "PlayStation8", description: "수량 1개 / 무료배송")
            ]
        }
    }
    
    @MainActor
    private func didTapPurchaseButton() async {
        
    }
}
