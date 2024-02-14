//
//  HomeThemeHeaderCollectionReusableView.swift
//  CProject
//
//  Created by Choi Oliver on 2/14/24.
//

import UIKit

struct HomeThemeHeaderCollectionReusableViewModel: Hashable {
    var headerText: String
}

class HomeThemeHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier: String = "HomeThemeHeaderCollectionReusableView"
    
    @IBOutlet weak var themeHeaderTitleLabel: UILabel!
    
    func setViewModel(_ viewModel: HomeThemeHeaderCollectionReusableViewModel) {
        themeHeaderTitleLabel.text = viewModel.headerText
    }
}
