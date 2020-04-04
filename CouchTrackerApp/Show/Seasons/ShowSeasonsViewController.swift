import CouchTrackerCore
import RxSwift

final class ShowSeasonsViewController: UITableViewController {
  private let disposeBag = DisposeBag()
  private var show: WatchedShowEntity?

  private func updateView(using newShow: WatchedShowEntity) {
    show = newShow
    tableView.reloadData()
  }

  init(show observable: Observable<WatchedShowEntity>) {
    super.init(style: .plain)

    observable
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] newShow in
        self?.updateView(using: newShow)
      }).disposed(by: disposeBag)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ShowSeasonCell")

    view.backgroundColor = Colors.View.background
    tableView.backgroundColor = Colors.View.background
  }

  override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    show?.seasons.count ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ShowSeasonCell", for: indexPath)

    let season = show?.seasons[indexPath.row]

    cell.backgroundColor = Colors.View.background

    cell.textLabel?.textColor = Colors.Text.primaryTextColor

    cell.textLabel?.text = "Season \(season?.number ?? -1) completed: \(season?.completed ?? 0)/\(season?.aired ?? 0)"

    return cell
  }
}
