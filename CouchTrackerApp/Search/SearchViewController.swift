import CouchTrackerCore
import RxSwift
import TraktSwift

final class SearchViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let presenter: SearchPresenter
  private let schedulers: Schedulers
  private let dataSource: UICollectionViewDataSource

  private var searchView: SearchView {
    guard let searchView = self.view as? SearchView else {
      preconditionFailure("self.view should be an instance of SearchView")
    }

    return searchView
  }

  init(presenter: SearchPresenter,
       dataSource: UICollectionViewDataSource,
       schedulers: Schedulers = DefaultSchedulers.instance) {
    self.presenter = presenter
    self.schedulers = schedulers
    self.dataSource = dataSource
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    Swift.fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = SearchView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    adjustForNavigationBar()
    extendedLayoutIncludesOpaqueBars = true
    configureCollectionView()

    view.backgroundColor = Colors.View.background

    searchView.emptyView.label.text = "HeyyY!!"

    presenter.observeSearchResults()
      .observeOn(schedulers.mainScheduler)
      .subscribe(onNext: { [weak self] resultState in
        self?.handleSearchResultState(resultState)
      }).disposed(by: disposeBag)

    presenter.observeSearchState()
      .observeOn(schedulers.mainScheduler)
      .subscribe(onNext: { [weak self] searchState in
        self?.handleSearchState(searchState)
      }).disposed(by: disposeBag)
  }

  private func configureCollectionView() {
    searchView.collectionView.backgroundColor = Colors.View.background

    searchView.collectionView.register(PosterAndTitleCell.self,
                                       forCellWithReuseIdentifier: PosterAndTitleCell.identifier)

    searchView.collectionView.dataSource = dataSource
    searchView.collectionView.delegate = self
  }

  private func handleSearchResultState(_: SearchResultState) {}

  private func handleSearchState(_: SearchState) {}

  private func searchChangedTo(state _: SearchState) {}

  private func handleEmptySearchResult() {
//    infoLabel.text = "No results"
//    collectionView.isHidden = true
//    infoLabel.isHidden = false
  }

  private func handleSearch(results _: [SearchResult]) {
//    self.results = results
//    collectionView.reloadData()
//    collectionView.isHidden = false
//    infoLabel.isHidden = true
  }

  private func handleError(message _: String) {
//    infoLabel.text = message
//    collectionView.isHidden = true
//    infoLabel.isHidden = false
  }
}

extension SearchViewController: UICollectionViewDelegate {
  func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("Selected item at \(indexPath.row)")
  }
}
