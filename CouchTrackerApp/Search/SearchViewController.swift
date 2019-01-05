import CouchTrackerCore
import RxSwift
import TraktSwift

final class SearchViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let presenter: SearchPresenter
  private let schedulers: Schedulers
  private let dataSource: SearchDataSource

  private var searchView: SearchView {
    guard let searchView = self.view as? SearchView else {
      preconditionFailure("self.view should be an instance of SearchView")
    }

    return searchView
  }

  init(presenter: SearchPresenter,
       dataSource: SearchDataSource,
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

    configureCollectionView()
    searchView.searchBar.delegate = self
    view.backgroundColor = Colors.View.background

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

  private func handleSearchState(_ state: SearchState) {
    switch state {
    case .notSearching:
      searchView.searchBar.resignFirstResponder()
    case .emptyResults:
      handleEmptySearchResult()
    case let .results(entities):
      handleSearch(entities: entities)
    case let .error(error):
      handleError(message: error.localizedDescription)
    case .searching:
      handleSearching()
    }
  }

  private func handleSearching() {
    searchView.emptyView.label.text = "Searching"
    searchView.emptyView.isHidden = false
  }

  private func handleEmptySearchResult() {
    searchView.emptyView.label.text = "Nothing found"
    searchView.emptyView.isHidden = false
  }

  private func handleSearch(entities: [SearchResultEntity]) {
    dataSource.entities = entities
    searchView.collectionView.reloadData()
    searchView.emptyView.isHidden = true
  }

  private func handleError(message: String) {
    searchView.emptyView.isHidden = false
    searchView.emptyView.label.text = message
  }
}

extension SearchViewController: UICollectionViewDelegate {
  func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let entity = dataSource.entities[indexPath.row]
    presenter.select(entity: entity)
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(true, animated: true)
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = nil
    searchBar.setShowsCancelButton(false, animated: true)
    searchBar.resignFirstResponder()

    presenter.cancelSearch()
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()

    guard let query = searchBar.text else { return }

    presenter.search(query: query)
  }
}
