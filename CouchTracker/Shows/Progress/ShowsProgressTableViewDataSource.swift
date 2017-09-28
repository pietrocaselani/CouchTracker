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

final class ShowsProgressTableViewDataSource: NSObject, UITableViewDataSource, ShowsProgressDataSource {
  private let imageRepository: ImageRepository
  private var viewModels = [WatchedShowViewModel]()

  init(imageRepository: ImageRepository) {
    self.imageRepository = imageRepository
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = R.reuseIdentifier.showProgressCell
    guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) else {
      fatalError("Can't dequeue cell with identifier \(identifier.identifier) on ShowsProgressViewController")
    }

    let viewModel = viewModels[indexPath.row]
    let interactor = ShowProgressCellService(imageRepository: imageRepository)
    let presenter = ShowProgressCelliOSPresenter(view: cell, interactor: interactor, viewModel: viewModel)

    cell.presenter = presenter

    return cell
  }

  func add(viewModel: WatchedShowViewModel) {
    viewModels.append(viewModel)
  }

  func viewModelCount() -> Int {
    return viewModels.count
  }

  func update() {
    viewModels.removeAll()
  }

  func set(viewModels: [WatchedShowViewModel]) {
    self.viewModels.removeAll()
    self.viewModels.append(contentsOf: viewModels)
  }
}
