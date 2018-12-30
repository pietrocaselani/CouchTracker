import CouchTrackerCore
import UIKit

final class ShowsProgressTableViewDataSource: NSObject, UITableViewDataSource, ShowsProgressViewDataSource {
  private let imageRepository: ImageRepository
  var viewModels: [WatchedShowViewModel] = [WatchedShowViewModel]()

  init(imageRepository: ImageRepository) {
    self.imageRepository = imageRepository
  }

  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return viewModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = R.reuseIdentifier.showProgressCell
    guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) else {
      fatalError("Can't dequeue cell with identifier \(identifier.identifier) on ShowsProgressViewController")
    }

    let viewModel: WatchedShowViewModel = viewModels[indexPath.row]
    let interactor = ShowProgressCellService(imageRepository: imageRepository)
    let presenter = ShowProgressCellDefaultPresenter(view: cell, interactor: interactor, viewModel: viewModel)

    cell.presenter = presenter

    return cell
  }

  func update() {
    viewModels.removeAll()
  }
}
