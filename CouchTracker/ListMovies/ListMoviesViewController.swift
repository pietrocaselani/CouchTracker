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

final class ListMoviesViewController: UIViewController, ListMoviesView {

  private typealias TrendingCellFactory = SimpleCollectionViewDataSource<TrendingViewModel>.CellFactory

  var presenter: ListMoviesPresenterOutput! = nil

  private var dataSource: SimpleCollectionViewDataSource<TrendingViewModel>!

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var emptyLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    emptyLabel.text = "Sorry!\nNo movies to show right now"
    collectionView.delegate = self

    configureMoviesDataSource()

    presenter.viewDidLoad()
  }

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

  func show(error: String) {
    showEmptyView()

    let errorAlert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
      errorAlert.dismiss(animated: true, completion: nil)
    }

    errorAlert.addAction(okAction)

    present(errorAlert, animated: true, completion: nil)
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

extension ListMoviesViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let navigable = navigationController else { return }

    presenter.showDetailsOfMovie(at: indexPath.row, navigable: navigable)
  }

}
