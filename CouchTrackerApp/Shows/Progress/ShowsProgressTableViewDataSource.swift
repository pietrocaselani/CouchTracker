import CouchTrackerCore

final class ShowsProgressTableViewDataSource: NSObject, ShowsProgressViewDataSource {
  private let interactor: ShowProgressCellInteractor
  var viewModels: [WatchedShowViewModel] = [WatchedShowViewModel]()

  init(interactor: ShowProgressCellInteractor) {
    self.interactor = interactor
  }

  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return viewModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = "ShowProgressCellIdentifier"
    let tableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

    guard let cell = tableViewCell as? ShowProgressCellView else {
      fatalError("Can't dequeue cell with identifier \(identifier) on ShowsProgressViewController")
    }

    let viewModel: WatchedShowViewModel = viewModels[indexPath.row]
    let presenter = ShowProgressCellDefaultPresenter(view: cell, interactor: interactor, viewModel: viewModel)

    cell.presenter = presenter

    return tableViewCell
  }
}
