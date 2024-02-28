//
//  HomeViewController.swift
//  CProject
//
//  Created by Choi Oliver on 2/14/24.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>

    private enum Section: Int {
        case banner
        case horizontalProductItem
        case seperateLine1
        case couponButton
        case verticalProductItem
        case seperateLine2
        case theme
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private lazy var dataSource: DataSource = setDataSource()
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = setCompositionalLayout()
    private var viewModel: HomeViewModel = .init()
    private var cancellable: Set<AnyCancellable> = .init()
    private var currentSection: [Section] {
        dataSource.snapshot().sectionIdentifiers as [Section]
    }
    private var didTapCouponDownload: PassthroughSubject<Void, Never> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingViewModel()
        collectionView.collectionViewLayout = compositionalLayout
        collectionView.delegate = self
        
        viewModel.process(action: .loadData)
        viewModel.process(action: .loadCoupon)
    }
    
    private func setCompositionalLayout() -> UICollectionViewCompositionalLayout {
        .init(
            sectionProvider: { [weak self] section, _ in
                
                switch self?.currentSection[section] {
                case .banner:
                    return HomeBannerCollectionViewCell.bannerLayout()
                case .horizontalProductItem:
                    return HomeProductCollectionViewCell.horizontalProductItemLayout()
                case .seperateLine1, .seperateLine2:
                    return HomeSeperateLineCollectionViewCell.seperateLineLayout()
                case .couponButton:
                    return HomeCouponButtonCollectionViewCell.couponButtonItemLayout()
                case .verticalProductItem:
                    return HomeProductCollectionViewCell.verticalProductItemLayout()
                case .theme:
                    return HomeThemeCollectionViewCell.themeLayout()
                case .none: return nil
                }
            }
        )
    }
    
    private func bindingViewModel() {
        viewModel.state.$collectionViewModels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapshot()
            }.store(in: &cancellable)
        
        didTapCouponDownload
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.process(action: .didTapCouponButton)
            }.store(in: &cancellable)
    }
    
    private func setDataSource() -> DataSource {
        let dataSource: DataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                guard let self else { return .init() }
                
                switch currentSection[indexPath.section] {
                case .banner:
                    return bannerCell(collectionView, indexPath, itemIdentifier)
                case .horizontalProductItem, .verticalProductItem:
                    return productItemCell(collectionView, indexPath, itemIdentifier)
                case .seperateLine1, .seperateLine2:
                    return seperateLineCell(collectionView, indexPath, itemIdentifier)
                case .couponButton:
                    return couponButtonCell(collectionView, indexPath, itemIdentifier)
                case .theme:
                    return themeCell(collectionView, indexPath, itemIdentifier)
                }
            }
        )
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self,
                  kind == UICollectionView.elementKindSectionHeader,
                  let viewModel = viewModel.state.collectionViewModels.themeViewModels?.header,
                  let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeThemeHeaderCollectionReusableView.identifier, for: indexPath) as? HomeThemeHeaderCollectionReusableView
            else {
                return nil
            }
            
            headerView.setViewModel(viewModel)
            return headerView
        }
        
        return dataSource
    }
    
    private func applySnapshot() {
        var snapshot: Snapshot = .init()
        
        if let bannerViewModels = viewModel.state.collectionViewModels.bannerViewModels {
            snapshot.appendSections([.banner])
            snapshot.appendItems(bannerViewModels, toSection: .banner)
        }
        
        if let horizontalProductViewModels = viewModel.state.collectionViewModels.horizontalProductViewModels {
            snapshot.appendSections([.horizontalProductItem])
            snapshot.appendItems(horizontalProductViewModels, toSection: .horizontalProductItem)
            
            snapshot.appendSections([.seperateLine1])
            snapshot.appendItems([viewModel.state.collectionViewModels.seperateLine1ViewModel], toSection: .seperateLine1)
        }
        
        if let couponState = viewModel.state.collectionViewModels.couponState {
            snapshot.appendSections([.couponButton])
            snapshot.appendItems([couponState], toSection: .couponButton)
        }
        
        if let verticalProductViewModels = viewModel.state.collectionViewModels.verticalProductViewModels {
            snapshot.appendSections([.verticalProductItem])
            snapshot.appendItems(verticalProductViewModels, toSection: .verticalProductItem)
        }
        
        if let themeViewModels = viewModel.state.collectionViewModels.themeViewModels {
            snapshot.appendSections([.seperateLine2])
            snapshot.appendItems([viewModel.state.collectionViewModels.seperateLine2ViewModel], toSection: .seperateLine2)
            
            snapshot.appendSections([.theme])
            snapshot.appendItems(themeViewModels.items, toSection: .theme)
        }
        
        dataSource.apply(snapshot)
    }
    
    private func bannerCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: AnyHashable) -> UICollectionViewCell {
        /*
         스토리보드 작업 내용이 반영되지 않는 문제가 발생
         let cell: HomeBannerCollectionViewCell = .init()
         */
        guard let viewModel = itemIdentifier as? HomeBannerCollectionViewCellViewModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBannerCollectionViewCell.identifier, for: indexPath) as? HomeBannerCollectionViewCell
        else { return .init() }
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func productItemCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = itemIdentifier as? HomeProductCollectionViewCellViewModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeProductCollectionViewCell.identifier, for: indexPath) as? HomeProductCollectionViewCell
        else { return .init() }
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func couponButtonCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = itemIdentifier as? HomeCouponButtonCollectionViewCellViewModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCouponButtonCollectionViewCell.identifier, for: indexPath) as? HomeCouponButtonCollectionViewCell
        else { return .init() }
        cell.setViewModel(viewModel, didTapCouponDownload)
        return cell
    }
    
    private func seperateLineCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = itemIdentifier as? HomeSeperateLineCollectionViewCellViewModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSeperateLineCollectionViewCell.identifier, for: indexPath) as? HomeSeperateLineCollectionViewCell
        else { return .init() }
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func themeCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = itemIdentifier as? HomeThemeCollectionViewCellViewModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeThemeCollectionViewCell.identifier, for: indexPath) as? HomeThemeCollectionViewCell
        else { return .init() }
        cell.setViewModel(viewModel)
        return cell
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        let favoriteStoryboard: UIStoryboard = .init(name: "Favorite", bundle: nil)
        guard let favoriteViewController = favoriteStoryboard.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(favoriteViewController, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentSection[indexPath.section] {
        case .banner:
            break
        case .seperateLine1, .seperateLine2:
            break
        case .couponButton:
            break
        case .horizontalProductItem, .verticalProductItem:
            let storyboard: UIStoryboard = UIStoryboard(name: "Detail", bundle: nil)
            guard let detailViewController = storyboard.instantiateInitialViewController() as? DetailViewController
            else { return }
            navigationController?.pushViewController(detailViewController, animated: true)
        case .theme:
            break
        }
    }
}

//#Preview {
//    UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeViewController
//}
