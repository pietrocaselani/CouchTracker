/*
 Copyright 2017 ArcTouch LLC.
 All rights reserved.

 This file, its contents, concepts, methods, behavior, and operation
 (collectively the "Software") are protected by trade secret, patent,
 and copyright laws. The use of the Software is governed by a license
 agreement. Disclosure of the Software to third parties, in any form,
 in whole or in part, is expressly prohibited except as authorized by
 the license agreement.
 */

import UIKit
import RxCocoa
import RxSwift

final class TrendingViewController: UIViewController {
  var presenter: TrendingPresenter!
  var searchView: SearchView!

  private let disposeBag = DisposeBag()

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var emptyLabel: UILabel!
  @IBOutlet weak var searchContainer: UIView!
  @IBOutlet weak var trendingTypeSegmentedControl: UISegmentedControl!

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let searchView = searchView as? UIView else {
      fatalError("searchView should be an instance of UIView")
    }

    guard let collectionViewDataSource = presenter.dataSource as? UICollectionViewDataSource else {
      fatalError("dataSource should be an instance of UICollectionViewDataSource")
    }

    trendingTypeSegmentedControl.setTitle(R.string.localizable.movies(), forSegmentAt: 0)
    trendingTypeSegmentedControl.setTitle(R.string.localizable.shows(), forSegmentAt: 1)

    trendingTypeSegmentedControl.rx.value
      .map { $0 == 0 ? TrendingType.movies : TrendingType.shows }
      .bind(to: presenter.currentTrendingType)
      .disposed(by: disposeBag)

    emptyLabel.text = "No movies to show right now".localized
    collectionView.delegate = self

    searchContainer.addSubview(searchView)

    collectionView.dataSource = collectionViewDataSource

    presenter.viewDidLoad()

    let settingsItem = UIBarButtonItem(image: R.image.settings(), style: .plain, target: nil, action: nil)
    settingsItem.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.presenter.showAppSettings()
    }).disposed(by: disposeBag)

    self.navigationItem.rightBarButtonItem = settingsItem
  }
}

extension TrendingViewController: TrendingView {
  func showTrendingsView() {
    makeListVisible()
    collectionView.reloadData()
  }

  func showEmptyView() {
    emptyLabel.isHidden = false
    collectionView.isHidden = true
  }

  private func makeListVisible() {
    emptyLabel.isHidden = true
    collectionView.isHidden = false
  }
}

extension TrendingViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    presenter.showDetailsOfTrending(at: indexPath.row)
  }
}
