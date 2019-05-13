import CouchTrackerCore

final class DebugMenuViewController: UITableViewController {
  private typealias S = DebugMenuViewController
  private static let cellIdentifier = "DebugCellIdentifier"

  private enum Settings: String, CaseIterable {
    case language = "Language"
  }

  private var currentLanguageIndex = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    updateCurrentSettingsValues()

    tableView.reloadData()
  }

  override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return Settings.allCases.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = dequeueValidCell(tableView: tableView)

    let settings = Settings.allCases[indexPath.row]

    cell.textLabel?.text = settings.rawValue
    cell.detailTextLabel?.text = currentValue(for: settings)

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    setNextValue(for: Settings.allCases[indexPath.row])

    tableView.reloadData()
  }

  private func currentValue(for settings: Settings) -> String {
    switch settings {
    case .language: return DefaultBundleProvider.instance.currentLanguage.rawValue
    }
  }

  private func setNextValue(for settings: Settings) {
    switch settings {
    case .language: updateLanguage()
    }
  }

  private func updateLanguage() {
    if currentLanguageIndex >= SupportedLanguages.allCases.count - 1 {
      currentLanguageIndex = 0
    } else {
      currentLanguageIndex += 1
    }

    let nextLanguage = SupportedLanguages.allCases[currentLanguageIndex]

    DefaultBundleProvider.update(language: nextLanguage)
  }

  private func updateCurrentSettingsValues() {
    let currentLanguage = DefaultBundleProvider.instance.currentLanguage
    currentLanguageIndex = SupportedLanguages.allCases.firstIndex(of: currentLanguage) ?? 0
  }

  private func dequeueValidCell(tableView: UITableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: S.cellIdentifier)
    return cell ?? UITableViewCell(style: .subtitle, reuseIdentifier: S.cellIdentifier)
  }
}
