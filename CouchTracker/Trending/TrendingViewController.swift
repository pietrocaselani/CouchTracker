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

  private typealias TrendingCellFactory = SimpleCollectionViewDataSource<TrendingViewModel>.CellFactory

  var presenter: TrendingPresenter!
  var searchView: SearchView!

  fileprivate var dataSource: SimpleCollectionViewDataSource<TrendingViewModel>!
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

    trendingTypeSegmentedControl.setTitle(R.string.localizable.movies(), forSegmentAt: 0)
    trendingTypeSegmentedControl.setTitle(R.string.localizable.shows(), forSegmentAt: 1)

    trendingTypeSegmentedControl.rx.value
        .map { $0 == 0 ? TrendingType.movies : TrendingType.shows }
        .bind(to: presenter.currentTrendingType)
        .disposed(by: disposeBag)

    emptyLabel.text = "Sorry!\nNo movies to show right now"
    collectionView.delegate = self

    configureMoviesDataSource()

    searchContainer.addSubview(searchView)

    presenter.viewDidLoad()
  }

  private func configureMoviesDataSource() {
    let cellFactory: TrendingCellFactory = { (collectionView, indexPath, model) -> UICollectionViewCell in

      let identifier = R.reuseIdentifier.trendingCell

      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) else {
        fatalError("cell isn't an instance of TrendingCell.")
      }

      cell.configure(for: model)

      return cell
    }

    dataSource = SimpleCollectionViewDataSource<TrendingViewModel>(cellFactory: cellFactory)
    self.collectionView.dataSource = dataSource
  }
}

extension TrendingViewController: TrendingView {
  func show(trending: [TrendingViewModel]) {
    makeListVisible()

    dataSource.elements = trending
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
