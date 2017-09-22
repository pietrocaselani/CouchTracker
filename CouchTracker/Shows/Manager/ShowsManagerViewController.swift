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

final class ShowsManagerViewController: UITableViewController, ShowsManagerView {
  var presenter: ShowsManagerPresenter!
  private let disposeBag = DisposeBag()
  private var titles = [String]()

  override func awakeFromNib() {
    super.awakeFromNib()

    self.title = R.string.localizable.shows()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    guard presenter != nil else {
      fatalError("ShowsManagerViewController was loaded without a presenter")
    }

    self.tableView.tableFooterView = UIView()
    presenter.viewDidLoad()
  }

  func showOptionsSelection(with titles: [String]) {
    self.titles = titles
    self.tableView.reloadData()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titles.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = R.reuseIdentifier.showsManagerCell
    guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) else {
      fatalError("What a terrible failure")
    }

    cell.textLabel?.text = titles[indexPath.row]

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.showOption(at: indexPath.row)
  }
}
