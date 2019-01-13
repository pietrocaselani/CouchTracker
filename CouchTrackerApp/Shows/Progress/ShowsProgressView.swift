import Cartography

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
    constrain(tableView) { table in
      table.top == table.superview!.top
      table.left == table.superview!.left
      table.right == table.superview!.right
      table.bottom == table.superview!.bottom
    }

    constrain(emptyView) { empty in
      empty.center == empty.superview!.center
    }
  }
}
