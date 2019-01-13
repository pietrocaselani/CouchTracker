import UIKit

import CouchTrackerApp
import CouchTrackerCore
import TraktSwift
import TMDBSwift
import TVDBSwift
import Kingfisher
import Cartography
import RxSwift

let posterLinks = [
  "https://image.tmdb.org/t/p/w154/pnUh2RawzYaSU8IjG61MT0AMRyf.jpg",
  "https://image.tmdb.org/t/p/w154/wBfEtXcnXtw5VJwChYU82CG6Att.jpg",
  "https://image.tmdb.org/t/p/w154/ooBGRQBdbGzBxAVfExiO8r7kloA.jpg",
  "https://image.tmdb.org/t/p/w154/clZCrt3Fan4Gt99gsUwTzoIA5CF.jpg",
  "https://image.tmdb.org/t/p/w154/4lpq3RwuecA6vLjxyYe6uVYNE2N.jpg",
  "https://image.tmdb.org/t/p/w154/22mSgZmStDb1luWdolYY3feLVW9.jpg",
  "https://image.tmdb.org/t/p/w154/eaZ5GWWzoid6R7NMBbTiLaQZM2W.jpg",
  "https://image.tmdb.org/t/p/w154/4F3QfeIimh0XUidhhWpruUitXvf.jpg"
]

private func fetchData() -> [WatchedShowViewModel] {
  return [
    WatchedShowViewModel(title: "How to Get Away With Murder",
                         nextEpisode: "5x5 It Was the Worst Day of My Life",
                         nextEpisodeDate: "Oct 25, 2018 (Thu)",
                         status: "4 remaining ABC (US) - Fri 1:00 AM",
                         tmdbId: nil),
    WatchedShowViewModel(title: "Once Upon a Time",
                         nextEpisode: nil,
                         nextEpisodeDate: "Ended",
                         status: "ABC (US) - Fri 11:00 PM",
                         tmdbId: nil),
    WatchedShowViewModel(title: "The Big Bang Theory",
                         nextEpisode: "12x11 The Paintball Scattering",
                         nextEpisodeDate: "Jan 03, 2018 (Thu)",
                         status: "1 remaining CBS - Thu 11:00 PM",
                         tmdbId: nil),
    WatchedShowViewModel(title: "DC's Legends of Tomorrow",
                         nextEpisode: nil,
                         nextEpisodeDate: "Continuing",
                         status: "The CW - Tue 12:00 AM",
                         tmdbId: nil),
  ]
}

final class ViewDemo: CouchTrackerApp.View {
  var didTouch: (() -> ())?

  let button: UIButton = {
    let button = UIButton()
    button.setTitle("Touch me", for: .normal)
    button.addTarget(self, action: #selector(touched(_:)), for: .touchUpInside)
    return button
  }()

  let tableView: UITableView = {
    return UITableView(frame: .zero, style: .plain)
  }()

  @objc private func touched(_ sender: Any?) {
    didTouch?()
  }

  override func initialize() {
    addSubview(button)
    addSubview(tableView)
  }

  override func installConstraints() {
    constrain(button, tableView) { (button, table) in
      button.top == button.superview!.top
      button.left == button.superview!.left

      table.top == button.bottom
      table.left == table.superview!.left
      table.right == table.superview!.right
      table.bottom == table.superview!.bottom
    }
  }
}

final class ShowProgressCellDemo: CouchTrackerApp.TableViewCell {
  static let identifier = "ShowProgressCellDemo"

  let posterImageView: UIImageView = {
    return UIImageView()
  }()

  let showTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.primaryTextColor
    return label
  }()

  let episodeTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.primaryTextColor
    return label
  }()

  let remainingAndNetworkLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.secondaryTextColor
    label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    return label
  }()

  let statusAndDateLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.Text.secondaryTextColor
    label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    return label
  }()

  private lazy var labelsStackView: UIStackView = {
    let subviews = [remainingAndNetworkLabel, showTitleLabel, episodeTitleLabel, statusAndDateLabel]
    let stack = UIStackView(arrangedSubviews: subviews)
    stack.axis = .vertical
    stack.distribution = .fillProportionally
    return stack
  }()

  override func initialize() {
    addSubview(labelsStackView)
    addSubview(posterImageView)
    backgroundColor = Colors.Cell.backgroundColor
  }

  override func installConstraints() {
    constrain(labelsStackView, posterImageView) { stack, poster in
      let margin: CGFloat = 5

      poster.height == poster.superview!.height - (margin * 2)
      poster.width == poster.height * 0.75
      poster.left == poster.superview!.left + margin
      poster.top == poster.superview!.top + margin
      poster.bottom == poster.superview!.bottom - margin

      stack.left == poster.right + margin
      stack.top == poster.top
      stack.bottom == poster.bottom
      stack.right == stack.superview!.right
    }
  }
}

public final class ShowProgressViewControllerDemo: UIViewController, UITableViewDataSource, UITableViewDelegate {
  private let data = fetchData()

  private var customView: ViewDemo {
    return self.view as! ViewDemo
  }

  private var tableView: UITableView {
    return customView.tableView
  }

  private var button: UIButton {
    return customView.button
  }

  public override func loadView() {

  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = Colors.View.background
    tableView.backgroundColor = Colors.View.background

    //    tableView.separatorStyle = .none

    //    let w: CGFloat = 50
    //    let height = Int(ViewCalculations.showProgressCellHeight(for: w))
    //    print(height)

    tableView.dataSource = self
    tableView.delegate = self

    customView.didTouch = { [weak self] in
      guard let cell = self?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) else { return }

      guard let showCell = cell as? ShowProgressCellDemo else { return }

      let size = cell.frame.size
      let posterSize = showCell.posterImageView.frame.size
      print("Cell size = \(size)")
      print("PosterImageViewSize = \(posterSize)")
    }

    let height = 100

    //    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ABC")
    tableView.register(ShowProgressCellDemo.self, forCellReuseIdentifier: ShowProgressCellDemo.identifier)
    tableView.rowHeight = CGFloat(height)
  }

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //    let tableCell = tableView.dequeueReusableCell(withIdentifier: "ABC", for: indexPath)
    let tableCell = tableView.dequeueReusableCell(withIdentifier: ShowProgressCellDemo.identifier,
                                                  for: indexPath)

    guard let cell = tableCell as? ShowProgressCellDemo else { Swift.fatalError() }

    let model = data[indexPath.row]

    //    cell.posterImageView.kf.setImage(with: posterLinks[indexPath.row].toURL)
    //    cell.showTitleLabel.text = model.title
    //    cell.episodeTitleLabel.text = model.nextEpisode
    //    cell.remainingAndNetworkLabel.text = model.status
    //    cell.statusLabel.text = model.nextEpisodeDate

    cell.posterImageView.kf.setImage(with: posterLinks[indexPath.row].toURL)
    cell.showTitleLabel.text = model.title
    cell.episodeTitleLabel.text = model.nextEpisode
    cell.statusAndDateLabel.text = model.nextEpisodeDate
    cell.remainingAndNetworkLabel.text = model.status

    //    tableCell.textLabel?.text = model.title

    return tableCell
  }

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

}
