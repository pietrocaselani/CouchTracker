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

final class ListMoviesViewController: UIViewController {

  private typealias TrendingCellFactory = SimpleCollectionViewDataSource<TrendingViewModel>.CellFactory

  var presenter: ListMoviesPresenter!
  var searchView: SearchView!

  fileprivate var dataSource: SimpleCollectionViewDataSource<TrendingViewModel>!

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var emptyLabel: UILabel!
  @IBOutlet weak var searchContainer: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let searchView = searchView as? UIView else {
      fatalError("searchView should be an instance of UIView")
    }

    emptyLabel.text = "Sorry!\nNo movies to show right now"
    collectionView.delegate = self

    configureMoviesDataSource()

    searchContainer.addSubview(searchView)

    presenter.fetchMovies()
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

extension ListMoviesViewController: ListMoviesView {
  func show(movies: [MovieViewModel]) {
    emptyLabel.isHidden = true
    collectionView.isHidden = false

    dataSource.elements = movies
    collectionView.reloadData()
  }

  func showEmptyView() {
    emptyLabel.isHidden = false
    collectionView.isHidden = true
  }
}

extension ListMoviesViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    presenter.showDetailsOfMovie(at: indexPath.row)
  }
}
