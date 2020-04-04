import CouchTrackerCore
import RxSwift

final class AppStateViewController: UITableViewController {
  private typealias Strings = CouchTrackerCoreStrings
  private static let defaultCellIdentifier = "DefaultAppConfigCell"
  private let disposeBag = DisposeBag()
  private let presenter: AppStatePresenter
  private let schedulers: Schedulers
  private var configurationSections = [AppStateViewModel]()

  init(presenter: AppStatePresenter, schedulers: Schedulers = DefaultSchedulers.instance) {
    self.presenter = presenter
    self.schedulers = schedulers

    super.init(style: .plain)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = Strings.settings()

    view.backgroundColor = Colors.View.background
    tableView.separatorColor = Colors.View.background

    presenter.observeViewState()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] viewState in
        self?.handleViewState(viewState)
      }).disposed(by: disposeBag)

    presenter.viewDidLoad()
  }

  private func handleViewState(_ state: AppStateViewState) {
    switch state {
    case .loading: break
    case let .showing(configs):
      showConfigurations(models: configs)
    }
  }

  private func showConfigurations(models: [AppStateViewModel]) {
    configurationSections.removeAll()
    configurationSections.append(contentsOf: models)
    tableView.reloadData()
  }

  override func numberOfSections(in _: UITableView) -> Int {
    configurationSections.count
  }

  override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard section < configurationSections.count else { return 0 }
    let section = configurationSections[section]
    return section.configurations.count
  }

  override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard section < configurationSections.count else { return nil }
    return configurationSections[section].title
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = AppStateViewController.defaultCellIdentifier

    let appConfigCell: UITableViewCell

    if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
      appConfigCell = cell
    } else {
      appConfigCell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
      appConfigCell.backgroundColor = Colors.View.background
      appConfigCell.textLabel?.textColor = Colors.Text.primaryTextColor
      appConfigCell.detailTextLabel?.textColor = Colors.Text.secondaryTextColor
    }

    let section = configurationSections[indexPath.section]
    let configuration = section.configurations[indexPath.row]

    appConfigCell.textLabel?.text = configuration.title
    appConfigCell.detailTextLabel?.text = configuration.subtitle

    switch configuration.value {
    case .none:
      appConfigCell.accessoryType = .none
    case let .hideSpecials(wantsToHideSpecials):
      appConfigCell.accessoryType = wantsToHideSpecials ? .checkmark : .none
    case let .traktLogin(wantsToLogin):
      appConfigCell.accessoryType = wantsToLogin ? .none : .checkmark
    case .externalURL:
      appConfigCell.accessoryType = .disclosureIndicator
    }

    return appConfigCell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let selectedConfigurationSection = configurationSections[indexPath.section]
    let selectedConfiguration = selectedConfigurationSection.configurations[indexPath.row]

    presenter.select(configuration: selectedConfiguration)
  }
}
