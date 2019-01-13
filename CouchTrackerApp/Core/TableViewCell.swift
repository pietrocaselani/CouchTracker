open class TableViewCell: UITableViewCell {
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  private func setup() {
    initialize()
    installConstraints()
  }

  open func initialize() {}

  open func installConstraints() {}
}
