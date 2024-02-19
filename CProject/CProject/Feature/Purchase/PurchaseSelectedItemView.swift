//
//  PurchaseSelectedItemView.swift
//  CProject
//
//  Created by Choi Oliver on 2/19/24.
//

import UIKit

struct PurchaseSelectedItemViewModel {
    var title: String
    var description: String
}

final class PurchaseSelectedItemView: UIView {
    private var contentStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var titleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = CPFont.UIKit.r12
        label.textColor = CPColor.UIKit.bk
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label: UILabel = .init()
        label.font = CPFont.UIKit.r12
        label.textColor = CPColor.UIKit.gray5
        return label
    }()
    
    var viewModel: PurchaseSelectedItemViewModel
    
    private var contentStackViewConstraints: [NSLayoutConstraint]?
    
    init(viewModel: PurchaseSelectedItemViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if contentStackViewConstraints == nil {
            let constraints = [
                contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            ]
            NSLayoutConstraint.activate(constraints)
            self.contentStackViewConstraints = constraints
        }
        
        super.updateConstraints()
    }
    
    private func commonInit() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        setBorder()
        setViewModel()
    }
    
    private func setBorder() {
        layer.borderColor = CPColor.UIKit.gray0.cgColor
        layer.borderWidth = 1
    }
    
    private func setViewModel() {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}
