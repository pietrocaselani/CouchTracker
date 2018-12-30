import ActionSheetPicker_3_0
import CouchTrackerCore
import RxCocoa
import RxSwift
import UIKit

final class ShowsProgressViewController: UIViewController, ShowsProgressView {
  var presenter: ShowsProgressPresenter!
  private let disposeBag = DisposeBag()
  @IBOutlet var tableView: UITableView!
  @IBOutlet var infoLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    guard presenter != nil else {
      fatalError("view loaded without a presenter")
    }

    guard let dataSource = presenter.dataSource as? UITableViewDataSource else {
      fatalError("dataSource should be an instance of UITableViewDataSource")
    }

    tableView.dataSource = dataSource
    tableView.delegate = self

    view.backgroundColor = Colors.View.background

    presenter.viewDidLoad()

    let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
    refreshItem.rx.tap.asDriver().drive(onNext: { [unowned self] in
      self.presenter.updateShows()
      self.tableView.reloadData()
    }).disposed(by: disposeBag)

    let filterItem = UIBarButtonItem(image: R.image.filter(), style: .plain, target: nil, action: nil)
    filterItem.rx.tap.asDriver().drive(onNext: { [unowned self] in
      self.presenter.handleFilter()
    }).disposed(by: disposeBag)

    let directionItem = UIBarButtonItem(image: R.image.direction(), style: .plain, target: nil, action: nil)
    directionItem.rx.tap.asDriver().drive(onNext: { [unowned self] in
      self.presenter.handleDirection()
    }).disposed(by: disposeBag)

    navigationItem.rightBarButtonItems = [filterItem, directionItem, refreshItem]
  }

  func show(viewModels _: [WatchedShowViewModel]) {
    showList()
    reloadList()
  }

  func showLoading() {
    infoLabel.text = "Loading"
    showInfoLabel()
  }

  func showError(message: String) {
    infoLabel.text = message
    showInfoLabel()
  }

  func showEmptyView() {
    infoLabel.text = "No data"
    showInfoLabel()
  }

  func reloadList() {
    tableView.reloadData()
  }

  func showOptions(for sorting: [String], for filtering: [String], currentSort: Int, currentFilter: Int) {
    let title = "Sort & Filter"
    let rows = [sorting, filtering]
    let initial = [currentSort, currentFilter]

    let picker = ActionSheetMultipleStringPicker(title: title,
                                                 rows: rows,
                                                 initialSelection: initial,
                                                 doneBlock: { [unowned self] _, indexes, _ in
                                                   let sortIndex = (indexes?[0] as? Int) ?? 0
                                                   let filterIndex = (indexes?[1] as? Int) ?? 0
                                                   self.presenter.changeSort(to: sortIndex, filter: filterIndex) },
                                                 cancel: { _ in },
                                                 origin: view)
    picker?.show()
  }

  private func showList() {
    infoLabel.isHidden = true
    tableView.isHidden = false
  }

  private func showInfoLabel() {
    infoLabel.isHidden = false
    tableView.isHidden = true
  }
}

extension ShowsProgressViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    presenter.selectedShow(at: indexPath.row)
  }
}
