import CouchTrackerCore
import UIKit

final class AppConfigurationsViewController: UIViewController, AppConfigurationsView, UITableViewDataSource {
  var presenter: AppConfigurationsPresenter!
  private var configurationSections = [AppConfigurationsViewModel]()

  @IBOutlet var tableView: UITableView!

  override func awakeFromNib() {
    super.awakeFromNib()

    title = R.string.localizable.settings()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    guard presenter != nil else {
      fatalError("AppConfigurationsViewController was loaded without a presenter")
    }

    tableView.dataSource = self
    tableView.delegate = self

    presenter.viewDidLoad()
  }

  func showConfigurations(models: [AppConfigurationsViewModel]) {
    configurationSections.removeAll()
    configurationSections.append(contentsOf: models)
    tableView.reloadData()
  }

  func numberOfSections(in _: UITableView) -> Int {
    return configurationSections.count
  }

  func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard section < configurationSections.count else { return 0 }
    let section = configurationSections[section]
    return section.configurations.count
  }

  func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard section < configurationSections.count else { return nil }
    return configurationSections[section].title
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = R.reuseIdentifier.appConfigurationsCell

    guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) else {
      fatalError("What a terrible failure - Dequeue AppConfigurationCell fail")
    }

    let section = configurationSections[indexPath.section]
    let configuration = section.configurations[indexPath.row]

    cell.textLabel?.text = configuration.title
    cell.detailTextLabel?.text = configuration.subtitle

    switch configuration.value {
    case .none:
      cell.accessoryType = .none
    case let .hideSpecials(wantsToHideSpecials):
      cell.accessoryType = wantsToHideSpecials ? .checkmark : .none
    case let .traktLogin(wantsToLogin):
      cell.accessoryType = wantsToLogin ? .none : .checkmark
    case .externalURL:
      cell.accessoryType = .disclosureIndicator
    }

    return cell
  }
}

extension AppConfigurationsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let selectedConfigurationSection = configurationSections[indexPath.section]
    let selectedConfiguration = selectedConfigurationSection.configurations[indexPath.row]

    presenter.select(configuration: selectedConfiguration)
  }
}
