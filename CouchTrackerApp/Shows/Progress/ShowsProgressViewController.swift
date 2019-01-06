import ActionSheetPicker_3_0
import CouchTrackerCore
import RxCocoa
import RxSwift

final class ShowsProgressViewController: UIViewController {
  private let presenter: ShowsProgressPresenter
  private let dataSource: ShowsProgressViewDataSource
  private let schedulers: Schedulers
  private let disposeBag = DisposeBag()

  init(presenter: ShowsProgressPresenter,
       dataSource: ShowsProgressViewDataSource,
       schedulers: Schedulers = DefaultSchedulers.instance) {
    self.presenter = presenter
    self.dataSource = dataSource
    self.schedulers = schedulers
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

//    tableView.dataSource = dataSource
//    tableView.delegate = self

    view.backgroundColor = Colors.View.background

    presenter.observeViewState()
      .observeOn(schedulers.mainScheduler)
      .subscribe(onNext: { [weak self] viewState in
        self?.handleViewState(viewState)
      }).disposed(by: disposeBag)
  }

  private func handleViewState(_ state: ShowProgressViewState) {
    cleanBarButtonItems()

    switch state {
    case .empty:
      print("[VIEW STATE] >>> Empty state")
    case .notLogged:
      print("[VIEW STATE] >>> Requires Trakt login")
    case .loading:
      print("[VIEW STATE] >>> Loading...")
    case let .error(error):
      print("[VIEW STATE] >>> Error: \(error.localizedDescription)")
    case let .shows(entities, menu):
      print("[VIEW STATE] >>> Showing \(entities.count) tv shows - \(menu)")
      configureBarButtonItems(menu: menu)
    }
  }

  private func cleanBarButtonItems() {
    navigationItem.rightBarButtonItems = nil
  }

  private func configureBarButtonItems(menu _: ShowsProgressMenuOptions) {
    let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
    refreshItem.rx.tap.asDriver().drive(onNext: { [weak self] in
      //      self.presenter.updateShows()
      //      self.tableView.reloadData()
    }).disposed(by: disposeBag)

    let filterItem = UIBarButtonItem(image: R.image.filter(), style: .plain, target: nil, action: nil)
    filterItem.rx.tap.asDriver().drive(onNext: { [weak self] in
      //      self.presenter.handleFilter()
    }).disposed(by: disposeBag)

    let directionItem = UIBarButtonItem(image: R.image.direction(), style: .plain, target: nil, action: nil)
    directionItem.rx.tap.asDriver().drive(onNext: { [weak self] in
      //      self.presenter.handleDirection()
    }).disposed(by: disposeBag)

    navigationItem.rightBarButtonItems = [filterItem, directionItem, refreshItem]
  }

  private func show(viewModels _: [WatchedShowViewModel]) {
    showList()
    reloadList()
  }

  private func showLoading() {
//    infoLabel.text = "Loading"
    showInfoLabel()
  }

  private func showError(message _: String) {
//    infoLabel.text = message
    showInfoLabel()
  }

  private func showEmptyView() {
//    infoLabel.text = "No data"
    showInfoLabel()
  }

  private func reloadList() {
//    tableView.reloadData()
  }

  private func showOptions(for sorting: [String], for filtering: [String], currentSort: Int, currentFilter: Int) {
    let title = "Sort & Filter"
    let rows = [sorting, filtering]
    let initial = [currentSort, currentFilter]

    let picker = ActionSheetMultipleStringPicker(title: title,
                                                 rows: rows,
                                                 initialSelection: initial,
                                                 doneBlock: { [unowned self] _, indexes, _ in
                                                   let sortIndex = (indexes?[0] as? Int) ?? 0
                                                   let filterIndex = (indexes?[1] as? Int) ?? 0
//                                                   self.presenter.changeSort(to: sortIndex, filter: filterIndex)
                                                 },
                                                 cancel: { _ in },
                                                 origin: view)
    picker?.show()
  }

  private func showList() {
//    infoLabel.isHidden = true
//    tableView.isHidden = false
  }

  private func showInfoLabel() {
//    infoLabel.isHidden = false
//    tableView.isHidden = true
  }
}

extension ShowsProgressViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
//    presenter.selectedShow(at: indexPath.row)
  }
}
