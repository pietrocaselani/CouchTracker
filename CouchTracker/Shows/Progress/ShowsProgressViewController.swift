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
import RxCocoa
import RxSwift

final class ShowsProgressViewController: UIViewController, ShowsProgressView {
  var presenter: ShowsProgressPresenter!
  private let disposeBag = DisposeBag()
  private var shouldReloadViewModels = false
  fileprivate var viewModels = [WatchedShowViewModel]()
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var infoLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    presenter.viewDidLoad()

    let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
    refreshItem.rx.tap.asDriver().drive(onNext: { [unowned self] in
      self.viewModels.removeAll()
      self.tableView.reloadData()
      self.presenter.updateShows()
    }).disposed(by: disposeBag)

    self.navigationItem.rightBarButtonItem = refreshItem
  }

  func showNew(viewModel: WatchedShowViewModel) {
    showList()
    viewModels.append(viewModel)
    tableView.insertRows(at: [IndexPath(row: viewModels.count - 1, section: 0)], with: .automatic)
  }

  func updateFinished() {
    if viewModels.isEmpty {
      showInfoLabel()
    }
  }

  private func showList() {
    if !tableView.isHidden {
      infoLabel.isHidden = true
      tableView.isHidden = false
    }
  }

  private func showInfoLabel() {
    if !infoLabel.isHidden {
      infoLabel.isHidden = false
      tableView.isHidden = true
    }
  }
}

extension ShowsProgressViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = R.reuseIdentifier.showProgressCell
    guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) else {
      fatalError("Can't dequeue cell with identifier \(identifier.identifier) on ShowsProgressViewController")
    }

    let viewModel = viewModels[indexPath.row]

    cell.textLabel?.text = viewModel.title

    if let nextEpisode = viewModel.nextEpisode {
      cell.detailTextLabel?.text = "\(viewModel.episodesRemaining) - \(nextEpisode)"
    } else {
      cell.detailTextLabel?.text = "\(viewModel.episodesRemaining) - \(viewModel.status)"
    }

    return cell
  }
}
