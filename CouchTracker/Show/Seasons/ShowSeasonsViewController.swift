import CouchTrackerCore
import RxSwift
import UIKit

final class ShowSeasonsViewController: UITableViewController {
  private let show: WatchedShowEntity

  init(show: WatchedShowEntity) {
    self.show = show
    super.init(style: .plain)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ShowSeasonCell")
  }

  override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return show.seasons.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ShowSeasonCell", for: indexPath)

    let season = show.seasons[indexPath.row]

    cell.textLabel?.text = "Season \(season.number) completed: \(season.completed ?? 0)/\(season.aired ?? 0)"

    return cell
  }
}
