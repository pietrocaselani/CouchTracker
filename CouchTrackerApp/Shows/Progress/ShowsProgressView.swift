import SnapKit

final class ShowsProgressView: View {
  let emptyView = DefaultEmptyView()

  let tableView: UITableView = {
    let table = UITableView(frame: .zero, style: .plain)
    table.rowHeight = 100
    table.separatorStyle = .none
    return table
  }()

  override func initialize() {
    addSubview(tableView)
    addSubview(emptyView)

    backgroundColor = Colors.View.background
    tableView.backgroundColor = Colors.View.background
  }

  override func installConstraints() {
    tableView.snp.makeConstraints { $0.size.equalToSuperview() }

    emptyView.snp.makeConstraints { $0.center.equalToSuperview() }
  }
}
