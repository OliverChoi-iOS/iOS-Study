//
//  FavoriteViewController.swift
//  CProject
//
//  Created by Choi Oliver on 2/15/24.
//

import UIKit
import Combine

final class FavoriteViewController: UIViewController {
    private typealias DataSource = UITableViewDiffableDataSource<Section, AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    private enum Section: Int {
        case favorite
    }
    
    private lazy var dataSource: DataSource = setDataSource()
    private var currentSection: [Section] {
        dataSource.snapshot().sectionIdentifiers as [Section]
    }
    private var viewModel: FavoriteViewModel = .init()
    private var cancellable: Set<AnyCancellable> = .init()

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        viewModel.process(action: .getFavoriteFromAPI)
    }
    
    private func bindViewModel() {
        viewModel.state.$tableViewModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapshot()
            }.store(in: &cancellable)
    }
}

extension FavoriteViewController {
    private func setDataSource() -> DataSource {
        let dataSource: DataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
                switch self?.currentSection[indexPath.section] {
                case .favorite:
                    return self?.favoriteCell(tableView, indexPath, itemIdentifier)
                case .none: return .init()
                }
            }
        )
        
        return dataSource
    }
    
    private func favoriteCell(_ tableView: UITableView, _ indexPath: IndexPath, _ itemIdentifier: AnyHashable) -> UITableViewCell? {
        guard let viewModel = itemIdentifier as? FavoriteItemTableViewCellViewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteItemTableViewCell.identifier, for: indexPath) as? FavoriteItemTableViewCell else { return nil }
        cell.setViewModel(viewModel)
        
        return cell
    }
    
    private func applySnapshot() {
        var snapshot: Snapshot = .init()
        
        if let favoriteItemViewModels = viewModel.state.tableViewModel {
            snapshot.appendSections([.favorite])
            snapshot.appendItems(favoriteItemViewModels, toSection: .favorite)
        }
        
        dataSource.apply(snapshot)
    }
}
