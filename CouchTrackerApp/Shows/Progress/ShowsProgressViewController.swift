import ActionSheetPicker_3_0
import CouchTrackerCore
import RxCocoa
import RxDataSources
import RxSwift

final class ShowsProgressViewController: UIViewController {
  private typealias Strings = CouchTrackerCoreStrings
  private let presenter: ShowsProgressPresenter
  private let cellInteractor: ShowProgressCellInteractor
  private let schedulers: Schedulers
  private let disposeBag = DisposeBag()

  private var showsView: ShowsProgressView {
    guard let showsView = self.view as? ShowsProgressView else {
      preconditionFailure("self.view should be an instance of ShowsProgressView")
    }
    return showsView
  }

  init(presenter: ShowsProgressPresenter,
       cellInteractor: ShowProgressCellInteractor,
       schedulers: Schedulers = DefaultSchedulers.instance) {
    self.presenter = presenter
    self.cellInteractor = cellInteractor
    self.schedulers = schedulers
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = ShowsProgressView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let tableView = showsView.tableView
    let cellIdentifier = ShowProgressCell.identifier
    let cellType = ShowProgressCell.self

    tableView.register(cellType, forCellReuseIdentifier: cellIdentifier)

    presenter.observeViewState()
      .observeOn(schedulers.mainScheduler)
      .do(onNext: { [weak self] viewState in
        self?.handleViewState(viewState)
      }).map { viewState -> [WatchedShowEntity]? in
        if case let .shows(entities, _) = viewState {
          return Array(entities)
        }
        return nil
      }.unwrap()
      .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier,
                                   cellType: cellType)) { [localCellInteractor = cellInteractor] _, model, cell in
                                    let viewModel = WatchedShowEntityMapper.viewModel(for: model)

                                    let presenter = ShowProgressCellDefaultPresenter(interactor: localCellInteractor, viewModel: viewModel)
                                    cell.presenter = presenter
      }.disposed(by: disposeBag)

    tableView.rx.modelSelected(WatchedShowEntity.self)
      .subscribe(onNext: { [localPresenter = presenter, localTableView = tableView] entity in
        localPresenter.select(show: entity)
        if let indexPath = localTableView.indexPathForSelectedRow {
          localTableView.deselectRow(at: indexPath, animated: true)
        }
      }).disposed(by: disposeBag)
  }

  private func handleViewState(_ state: ShowProgressViewState) {
    cleanBarButtonItems()

    switch state {
    case .empty:
      showEmptyData(message: "Go watch some shows") // TODO: Translate
    case .filterEmpty:
      showEmptyData(message: "A lot of filters!") // TODO: Translate
    case .notLogged:
      showNotLogged()
    case .loading:
      showLoadingData()
    case let .error(error):
      showError(error: error)
    case let .shows(_, menu):
      showData(menu: menu)
    }
  }

  private func showEmptyData(message: String) {
    showsView.tableView.isHidden = true
    showsView.emptyView.isHidden = false
    showsView.emptyView.label.text = message
  }

  private func showData(menu: ShowsProgressMenuOptions) {
    configureBarButtonItems(menu: menu)

    showsView.emptyView.isHidden = true
    showsView.tableView.isHidden = false
  }

  private func showError(error: Error) {
    let errorAlert = UIAlertController.createErrorAlert(message: error.localizedDescription)
    present(errorAlert, animated: true, completion: nil)
  }

  private func showNotLogged() {
    showsView.tableView.isHidden = true
    showsView.emptyView.isHidden = false
    showsView.emptyView.label.text = Strings.requiresTraktLogin()
  }

  private func showLoadingData() {
    showsView.tableView.isHidden = true
    showsView.emptyView.isHidden = false
    showsView.emptyView.label.text = "Loading..." // TODO: Translate
  }

  private func cleanBarButtonItems() {
    navigationItem.rightBarButtonItems = nil
  }

  private func configureBarButtonItems(menu: ShowsProgressMenuOptions) {
    let sortTitles = menu.sort.map { $0.rawValue } // TODO: Translate
    let filterTitles = menu.filter.map { $0.rawValue } // TODO: Translate

    let filterItem = UIBarButtonItem(image: Images.filter(), style: .plain, target: nil, action: nil)
    filterItem.rx.tap.asDriver().drive(onNext: { [weak self] in
      self?.showOptions(sorting: sortTitles, filtering: filterTitles,
                        currentSort: menu.currentSort, currentFilter: menu.currentFilter)
    }).disposed(by: disposeBag)

    let directionItem = UIBarButtonItem(image: Images.direction(), style: .plain, target: nil, action: nil)

    directionItem.rx.tap.flatMapLatest { [localPresenter = presenter] in
      localPresenter.toggleDirection()
    }.subscribe()
      .disposed(by: disposeBag)

    pageboyParent?.navigationItem.rightBarButtonItems = [filterItem, directionItem]
    navigationItem.rightBarButtonItems = [filterItem, directionItem]
  }

  private func showOptions(sorting: [String], filtering: [String],
                           currentSort: ShowProgressSort, currentFilter: ShowProgressFilter) {
    let initialSort = sorting.firstIndex(of: currentSort.rawValue) ?? 0 // TODO: Translate
    let initialFilter = filtering.firstIndex(of: currentFilter.rawValue) ?? 0 // TODO: Translate

    let title = "Sort & Filter" // TODO: Translate
    let rows = [sorting, filtering]
    let initial = [initialSort, initialFilter]

    let picker = ActionSheetMultipleStringPicker(title: title,
                                                 rows: rows,
                                                 initialSelection: initial,
                                                 doneBlock: { [weak self] _, indexes, _ in
                                                  let sortIndex = (indexes?[0] as? Int) ?? 0
                                                  let filterIndex = (indexes?[1] as? Int) ?? 0

                                                  let sort = ShowProgressSort.allValues()[sortIndex]
                                                  let filter = ShowProgressFilter.allValues()[filterIndex]

                                                  self?.change(sort: sort, filter: filter)
      },
                                                 cancel: { _ in },
                                                 origin: view)
    picker?.show()
  }

  private func change(sort: ShowProgressSort, filter: ShowProgressFilter) {
    presenter.change(sort: sort, filter: filter).subscribe().disposed(by: disposeBag)
  }
}
