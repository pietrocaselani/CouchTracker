import UIKit

final class ShowManagerViewController: UITableViewController, ShowManagerView {
  var presenter: ShowManagerPresenter!
  private var titles = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()

    guard presenter != nil else {
      fatalError("View loaded without a prenseter")
    }

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
    let identifier = R.reuseIdentifier.showManagerCell
    guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) else {
      fatalError("Unable to dequeue ShowManager cell")
    }

    cell.textLabel?.text = titles[indexPath.row]

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.showOption(at: indexPath.row)
  }
}
