import CouchTrackerCore
import TraktSwift
import UIKit

final class SearchViewController: UIViewController, SearchResultOutput {
  @IBOutlet var searchViewContainer: UIView!
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var infoLabel: UILabel!

  var imageRepository: ImageRepository!
  var searchView: SearchView!

  private var results = [SearchResult]()

  override func viewDidLoad() {
    super.viewDidLoad()

    guard imageRepository != nil else {
      Swift.fatalError("view loaded without imageRepository")
    }

    guard let searchView = searchView as? UIView else {
      Swift.fatalError("searchView should be an instance of UIView")
    }

    collectionView.register(R.nib.posterCell(), forCellWithReuseIdentifier: R.nib.posterCell.identifier)

    searchViewContainer.addSubview(searchView)
    collectionView.dataSource = self
  }

  func searchChangedTo(state _: SearchState) {}

  func handleEmptySearchResult() {
    infoLabel.text = "No results"
    collectionView.isHidden = true
    infoLabel.isHidden = false
  }

  func handleSearch(results: [SearchResult]) {
    self.results = results
    collectionView.reloadData()
    collectionView.isHidden = false
    infoLabel.isHidden = true
  }

  func handleError(message: String) {
    infoLabel.text = message
    collectionView.isHidden = true
    infoLabel.isHidden = false
  }
}

extension SearchViewController: UICollectionViewDataSource {
  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return results.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let identifier = R.reuseIdentifier.posterCell

    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) else {
      Swift.fatalError("cell can't be nil")
    }

    let result = results[indexPath.row]

    let viewModel: PosterViewModel

    switch result.type {
    case .movie:
      guard let movie = result.movie else { Swift.fatalError("Result type is movie, but there is no movie!") }
      viewModel = PosterMovieViewModelMapper.viewModel(for: movie)
    case .show:
      guard let show = result.show else { Swift.fatalError("Result type is show, but there is no show!") }
      viewModel = PosterShowViewModelMapper.viewModel(for: show)
    default:
      Swift.fatalError("Result type not implemented yet")
    }

    let interactor = PosterCellService(imageRepository: imageRepository)
    let presenter = PosterCellDefaultPresenter(view: cell, interactor: interactor, viewModel: viewModel)

    cell.presenter = presenter

    return cell
  }
}
